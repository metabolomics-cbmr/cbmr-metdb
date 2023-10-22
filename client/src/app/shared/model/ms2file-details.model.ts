/**
 * MS2 File Info Response Containing multiple Compounds
 */
export interface MS2FileDetails {
  dets: Array<MS2FileCompoundShortObject[]>;
  mst: Mst;
}

export interface MS2FileCompoundShortObject {
  collision_energy: number;
  compound_name: string;
  id: number;
  retention_time_secs: string;
  spec_scan_num: number;
}

export interface Mst {
  data_source_name: string;
  file_name: string;
  id: number;
  import_date: string;
  mass_spectype_name: string;
  predicted_experimental: string;
}

/**
 * MS2 File Single Compound Response based on the id from the compound list.
 */
export interface MS2FileCompoundResponse {
  dets: MS2FileCompound[];
}

export interface MS2FileCompound {
  det: MS2CompoundDet[];
  peaks: MS2CompoundPeak[];
}

export interface MS2CompoundDet {
  base_peak_intensity: number;
  base_peak_mz: string;
  centroided: boolean;
  collision_energy: number;
  compound_name: string;
  from_file: string;
  high_mz: string;
  id: number;
  injection_time_secs: number;
  ionisation_energy: number;
  low_mz: string;
  ms_level: number;
  original_peaks_count: number;
  peak_id: string;
  peak_index: number;
  polarity: string;
  prec_scan_num: number;
  precursor_charge: string;
  precursor_intensity: number;
  precursor_mass: string;
  retention_time_secs: string;
  scan_index: number;
  spec_scan_num: number;
  spectrum_id: string;
  total_ion_current: number;
}

// export interface Mst {
//   compound_name: string;
//   data_source_name: string;
//   file_format: string;
//   file_name: string;
//   id: number;
//   import_date: string;
//   mass_spectype_name: string;
//   predicted_experimental: string;
//   spectrum_id: number;
// }

export interface MS2CompoundPeak {
  id: number;
  intensity: number;
  mz: string;
}
