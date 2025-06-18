#!/usr/bin/env python3
"""
BombCell processing for multiple mice in CTA backwards directory
Processes animals starting with calca_2 or calca_3, using the last two days for each mouse.
"""

import os
import sys
import numpy as np
from pathlib import Path
from datetime import datetime
import glob

# Add bombcell to path
sys.path.append('/home/jf5479/Dropbox/Python/bombcell/py_bombcell')
import bombcell as bc

def find_animals_and_days(base_dir):
    """Find animals starting with calca_2 or calca_3 and get their last two days."""
    base_path = Path(base_dir)
    animals = []
    
    # Find all animal directories
    for animal_dir in sorted(base_path.glob("calca_[23]*")):
        if not animal_dir.is_dir():
            continue
            
        animal_name = animal_dir.name
        print(f"Found animal: {animal_name}")
        
        # Find all date directories for this animal
        date_dirs = []
        for date_dir in animal_dir.iterdir():
            if date_dir.is_dir() and date_dir.name.startswith("202"):
                date_dirs.append(date_dir)
        
        # Sort by date and take last two
        date_dirs.sort(key=lambda x: x.name)
        last_two_days = date_dirs[-2:] if len(date_dirs) >= 2 else date_dirs
        
        print(f"  Available days: {[d.name for d in date_dirs]}")
        print(f"  Using last two days: {[d.name for d in last_two_days]}")
        
        # Check for Kilosort and raw data in each day
        valid_sessions = []
        for day_dir in last_two_days:
            session_info = check_session_data(day_dir)
            if session_info:
                valid_sessions.append(session_info)
        
        if valid_sessions:
            animals.append({
                'name': animal_name,
                'sessions': valid_sessions
            })
            print(f"  Valid sessions found: {len(valid_sessions)}")
        else:
            print(f"  No valid sessions found for {animal_name}")
        print()
    
    return animals

def check_session_data(day_dir):
    """Check if a day directory has both Kilosort output and raw data."""
    # Look for kilosort directories
    kilosort_dirs = []
    for pattern in ["kilosort4", "kilosort3", "kilosort"]:
        kilosort_dirs.extend(list(day_dir.rglob(pattern)))
    
    if not kilosort_dirs:
        print(f"    No Kilosort directory found in {day_dir}")
        return None
    
    # Use the first kilosort directory found
    ks_dir = kilosort_dirs[0]
    
    # Check for required Kilosort files
    required_files = ['spike_times.npy', 'spike_clusters.npy', 'templates.npy']
    missing_files = []
    for file in required_files:
        if not (ks_dir / file).exists():
            missing_files.append(file)
    
    if missing_files:
        print(f"    Missing Kilosort files in {ks_dir}: {missing_files}")
        return None
    
    # Look for raw data files (.ap.bin and .ap.meta)
    session_path = ks_dir.parent
    raw_files = list(session_path.glob("*.ap.bin"))
    meta_files = list(session_path.glob("*.ap.meta"))
    
    if not raw_files:
        print(f"    No .ap.bin file found in {session_path}")
        return None
    
    if not meta_files:
        print(f"    No .ap.meta file found in {session_path}")
        return None
    
    return {
        'day_name': day_dir.name,
        'ks_dir': str(ks_dir),
        'raw_file': str(raw_files[0]),
        'meta_file': str(meta_files[0]),
        'session_path': str(session_path)
    }

def run_bombcell_for_session(session_info, animal_name):
    """Run BombCell for a single session."""
    try:
        print(f"  Processing session: {session_info['day_name']}")
        print(f"    Kilosort dir: {session_info['ks_dir']}")
        print(f"    Raw file: {session_info['raw_file']}")
        print(f"    Meta file: {session_info['meta_file']}")
        
        # Get UnitMatch-optimized BombCell parameters
        param = bc.default_parameters.get_unit_match_parameters(
            session_info['ks_dir'], 
            raw_file=session_info['raw_file'],
            meta_file=session_info['meta_file'],
            kilosort_version=4
        )
        
        # Speed optimizations
        param['computeDistanceMetrics'] = False
        param['computeDrift'] = False
        param['saveAsTSV'] = True
        param['plotGlobal'] = False
        param['plotDetails'] = False
        param['nRawSpikesToExtract'] = 100
        
        # Verify settings
        print(f"    extractRaw: {param.get('extractRaw', False)}")
        print(f"    saveMultipleRaw: {param.get('saveMultipleRaw', False)}")
        print(f"    nRawSpikesToExtract: {param.get('nRawSpikesToExtract', 'Unknown')}")
        
        # Set BombCell output directory
        bc_output_dir = Path(session_info['session_path']) / 'bombcell_testing_jf'
        
        # Run BombCell
        print(f"    Running BombCell...")
        (quality_metrics, param, unit_type, unit_type_string) = bc.run_bombcell(
            session_info['ks_dir'], bc_output_dir, param
        )
        
        # Check results
        total_units = len(quality_metrics['phy_clusterID'])
        good_units = sum(np.array(unit_type_string) == 'GOOD')
        print(f"    ✅ Success: {total_units} total units, {good_units} good units")
        
        # Check raw waveforms
        raw_waveforms_dir = bc_output_dir / 'RawWaveforms'
        if raw_waveforms_dir.exists():
            npy_files = list(raw_waveforms_dir.glob('*.npy'))
            print(f"    Raw waveform files saved: {len(npy_files)}")
        else:
            print(f"    ❌ RawWaveforms directory not found!")
        
        return {
            'success': True,
            'total_units': total_units,
            'good_units': good_units,
            'bc_output_dir': str(bc_output_dir),
            'raw_waveforms_count': len(npy_files) if 'npy_files' in locals() else 0
        }
        
    except Exception as e:
        print(f"    ❌ Error processing {session_info['day_name']}: {e}")
        import traceback
        traceback.print_exc()
        return {
            'success': False,
            'error': str(e)
        }

def main():
    """Main processing function."""
    print("🚀 Starting BombCell processing for multiple mice")
    print("=" * 60)
    
    base_dir = "/home/jf5479/cup/Chris/data/cta_backwards"
    
    # Find all animals and their sessions
    print("🔍 Finding animals and sessions...")
    animals = find_animals_and_days(base_dir)
    
    if not animals:
        print("❌ No animals found with valid sessions!")
        return
    
    print(f"Found {len(animals)} animals with valid sessions:")
    for animal in animals:
        print(f"  - {animal['name']}: {len(animal['sessions'])} sessions")
    print()
    
    # Process each animal
    results = {}
    total_sessions = sum(len(animal['sessions']) for animal in animals)
    current_session = 0
    
    for animal in animals:
        print(f"🐭 Processing animal: {animal['name']}")
        print("-" * 40)
        
        animal_results = []
        for session in animal['sessions']:
            current_session += 1
            print(f"[{current_session}/{total_sessions}] ", end="")
            
            result = run_bombcell_for_session(session, animal['name'])
            result['session_info'] = session
            animal_results.append(result)
            print()
        
        results[animal['name']] = animal_results
        print()
    
    # Print summary
    print("📊 PROCESSING SUMMARY")
    print("=" * 60)
    
    total_processed = 0
    total_successful = 0
    total_units = 0
    total_good_units = 0
    
    for animal_name, animal_results in results.items():
        print(f"{animal_name}:")
        successful_sessions = 0
        animal_units = 0
        animal_good_units = 0
        
        for result in animal_results:
            total_processed += 1
            if result['success']:
                total_successful += 1
                successful_sessions += 1
                animal_units += result['total_units']
                animal_good_units += result['good_units']
        
        total_units += animal_units
        total_good_units += animal_good_units
        
        print(f"  Sessions: {successful_sessions}/{len(animal_results)} successful")
        print(f"  Units: {animal_units} total, {animal_good_units} good")
        print()
    
    print(f"OVERALL:")
    print(f"  Animals processed: {len(animals)}")
    print(f"  Sessions: {total_successful}/{total_processed} successful")
    print(f"  Total units: {total_units}")
    print(f"  Good units: {total_good_units}")
    
    success_rate = (total_successful / total_processed * 100) if total_processed > 0 else 0
    print(f"  Success rate: {success_rate:.1f}%")
    
    print("\n🎉 Processing complete!")

if __name__ == "__main__":
    main()