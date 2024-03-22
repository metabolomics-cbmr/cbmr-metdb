import { useState, useCallback, useEffect } from 'react';
import { getISADataListAPI } from '../../../shared/utils/api.utils';


export const useISADataInfo = <T>(
  initialValue: any,
  pagination?: string,
) => {
  const [records, setRecords] = useState<T>(initialValue);
  const [loading, setLoading] = useState(false);
  const [totalRecords, setTotalRecords] = useState(10);

  
  const getRecordsFromAPI = useCallback(async () => {
    try {
      setLoading(true);
      const result = await getISADataListAPI(
        pagination,
      );

      const invcount = result["invcount"]
      let total = invcount["totalrecords"]
      console.log("TOTAL " + total)
      setRecords(result["mst"]);
      setTotalRecords(parseInt(total, 10));
      

    } catch (error) {
      alert('Could not Get the Records');
      console.log({ recordsError: error });
    } finally {
      setLoading(false);
    }
  }, [pagination]);

  const initializePageData = () => {
    getRecordsFromAPI();
  };

  useEffect(initializePageData, [getRecordsFromAPI]);

  return { records, loading, totalRecords };
};


// const useISADataInfo = ({ investigationId, onClose }) => {
//   const [isaDataDetails, setISADataDetails] = useState<ISADataDetails[]>([]);

//   const getDetails = useCallback(async () => {
//     try {
//       const isaDataDets = await getISADataDetails(investigationId);

//       //setISADataDetails(isaDataDetails.concat(isaDataDets["mst"]));
//       setISADataDetails(isaDataDets);
//     } catch (error) {
//       alert('Could not get ISA Data Details');
//       console.log({ isaDataError: error });
//       onClose();
//     }
//   }, [investigationId, onClose]);

  
//   useEffect(() => {
//     if (!investigationId) {
//       alert('Invalid Investigation Id');
//       onClose();
//     } else {
//       console.log(" In GETTTTT")
//       getDetails();
//     }
//   }, [investigationId, onClose, getDetails]);

//   return isaDataDetails;
// };

export default useISADataInfo;
