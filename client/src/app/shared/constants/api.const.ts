export const BASE_URL = process.env.REACT_APP_BASE_URL;

const API_URLS = {
  DASHBOARD: `${BASE_URL}/v1/dashboarddata`,
  GET_IMPORTED_MS1: `${BASE_URL}/v1/displayms1/1,%20external`,
  GET_IMPORTED_MS2: `${BASE_URL}/v1/displayms2/1,%20external`,
  GET_UNKNOWN_COMPOUNDS: `${BASE_URL}/v1/displayresults/%%ID%%,%20external, %%DISPLAY_ONLY_MATCHING_Y/N%%`,
  UPLOAD_MS1: `${BASE_URL}/v1/upload_ms1/external`,
  UPLOAD_MS2: `${BASE_URL}/v1/upload_ms2/external`,
  UPLOAD_UNKNOWN_COMPOUNDS: `${BASE_URL}/v1/upload_ums2/external`,
  EXPORT_UNKNOWN_COMPOUNDS_TO_EXCEL: `${BASE_URL}/v1/resultsexcel/%%ID%%,%20external, %%DISPLAY_ONLY_MATCHING_Y/N%%`,
  RECORDS: `${BASE_URL}/v1/dashboarddata`,
  MS2_FILE_DETAILS: `${BASE_URL}/v1/ms2list/%%ID%%,%20external`,
  MS2_FILE_COMPOUND: `${BASE_URL}/v1/ms2dets/%%ID%%,%20external`,
  COMPARISON_RESULTS: `${BASE_URL}/v1/resultslog/external`,
  GET_COMPARISION_SETTINGS: `${BASE_URL}/v1/compareconfig`,
};

export default API_URLS;
