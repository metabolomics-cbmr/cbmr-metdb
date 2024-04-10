import { useCallback, useEffect, useState } from 'react';
import { RECORD_NAME_API_ENUM } from '../../../shared/constants/records.const';
import {
  getDashboardDataAPI,
  getRecords,
} from '../../../shared/utils/api.utils';

export const useRecords = <T>(
  initialValue: any,
  recordname: string,
  pagination?: string,
) => {
  const [records, setRecords] = useState<T>(initialValue);
  const [loading, setLoading] = useState(false);
  const [totalRecords, setTotalRecords] = useState(10);

  const getTotalRecords = useCallback(async () => {
    const getTotalRecordsFromDashboard = async () => {
      const dashboardData = await getDashboardDataAPI();
      if (recordname === 'TOTAL_COMPOUNDS') {
        return dashboardData.STATS.TOTAL_COMPOUNDS;
      } else if (recordname.includes('MISSING')) {
        return dashboardData.MISSING_DATA[recordname] || '10';
      }
      return '10';
    };
    const total = await getTotalRecordsFromDashboard();
    setTotalRecords(parseInt(total, 10));
  }, [recordname]);

  const getRecordsFromAPI = useCallback(async () => {
    try {
      setLoading(true);
      const result = await getRecords<T>(
        RECORD_NAME_API_ENUM[recordname] || recordname,
        pagination,
      );
      setRecords(result);
    } catch (error) {
      alert('Could not Get the Records');
      console.log({ recordsError: error });
    } finally {
      setLoading(false);
    }
  }, [recordname, pagination]);

  const initializePageData = () => {
    getRecordsFromAPI();
    getTotalRecords();
  };

  useEffect(initializePageData, [getRecordsFromAPI, getTotalRecords]);

  return { records, loading, totalRecords };
};
