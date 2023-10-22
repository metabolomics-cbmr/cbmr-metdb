import API_URLS from '../constants/api.const';
import { RECORD_NAME_API_ENUM } from '../constants/records.const';
import {
  ComparisionSettings,
  NewComparisonSettings,
} from '../model/comparision.model';
import { DashboardData } from '../model/dashboard.model';
import {
  MS2FileCompoundResponse,
  MS2FileDetails,
} from '../model/ms2file-details.model';
import { ResultLog } from '../model/results.model';
import { UnknownCompoundDetectionAPIResult } from '../model/unknown-compound-detection.model';
import http from './http';

export const getDashboardDataAPI = () =>
  http.get<DashboardData>(API_URLS.DASHBOARD);

export const uploadFile = (
  url: string,
  key: string,
  file: File,
  additionalUploadData: any = {},
) => {
  const formData = new FormData();
  formData.append(key, file);
  Object.entries(additionalUploadData).forEach(([key, value]) => {
    formData.append(key, `${value}`);
  });
  return http.post(url, formData);
};

export const getUnknownCompoundDetectionDetails = (
  resultId: string,
  displayMatchingResults: boolean,
) => {
  return http.get<UnknownCompoundDetectionAPIResult>(
    API_URLS.GET_UNKNOWN_COMPOUNDS.replace('%%ID%%', resultId).replace(
      '%%DISPLAY_ONLY_MATCHING_Y/N%%',
      displayMatchingResults ? 'Y' : 'N',
    ),
  );
};

export const getRecords = <T>(
  recordName: RECORD_NAME_API_ENUM,
  pagination?: string,
) => {
  // TODO: Implement Pagination
  return http.get<T>(
    `${API_URLS.RECORDS}/${recordName}${pagination ? `/${pagination}` : ''}`,
  );
};

export const getMS2FileDetails = (ms2FileId) => {
  return http.get<MS2FileDetails>(
    `${API_URLS.MS2_FILE_DETAILS.replace('%%ID%%', ms2FileId)}`,
  );
};

export const getMS2FileCompoundDetails = (ms2CompoundId) => {
  return http.get<MS2FileCompoundResponse>(
    `${API_URLS.MS2_FILE_COMPOUND.replace('%%ID%%', ms2CompoundId)}`,
  );
};

export const getComparisonResults = () => {
  return http.get<ResultLog[]>(API_URLS.COMPARISON_RESULTS);
};

export const getComparisionSettings = () => {
  return http.get<ComparisionSettings[]>(API_URLS.GET_COMPARISION_SETTINGS);
};

export const saveComparisionSettings = (
  newComparisonSettings: NewComparisonSettings,
) => {
  const formData = new FormData();
  Object.entries(newComparisonSettings).forEach(([key, value]) =>
    formData.append(key, value),
  );
  return http.post<any>(API_URLS.GET_COMPARISION_SETTINGS, formData);
};

/**
 * Activate/Deactivate a Comparison Setting
 */
export const changeCompatisonSettingStatus = (id, status) => {
  if (!status) {
    return http.delete(`${API_URLS.GET_COMPARISION_SETTINGS}/${id}`);
  }
};

export const unknownCompoundDetection = (
  comparisonFile: File,
  comparisonConfigId: string,
) => {
  const comparisonFormData = new FormData();
  comparisonFormData.append('file', comparisonFile);
  comparisonFormData.append('config', comparisonConfigId);
  return http.post(API_URLS.UPLOAD_UNKNOWN_COMPOUNDS, comparisonFormData);
};

export const exportUnknownCompoundDetectionToExcel = async (
  resultId: string | number,
  displayMatchingResults: boolean,
) => {
  const excelFileUrl = API_URLS.EXPORT_UNKNOWN_COMPOUNDS_TO_EXCEL.replace(
    '%%ID%%',
    `${resultId}`,
  ).replace(
    '%%DISPLAY_ONLY_MATCHING_Y/N%%',
    displayMatchingResults ? 'Y' : 'N',
  );
  const excelFile = await http.getFile(excelFileUrl);
  const excelFileName = `Unknown Compound Detection Result for id ${resultId}.xlsx`;
  return downloadFile(excelFile, excelFileName);
};

const downloadFile = (blob: Blob, name: string) => {
  const link = document.createElement('a');
  link.href = window.URL.createObjectURL(blob);
  link.download = name;
  link.click();
};
