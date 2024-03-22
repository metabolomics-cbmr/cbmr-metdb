import { useState, useCallback, useEffect } from 'react';
import { ISADataDetails } from '../../../shared/model/isadata-details.model';
import { getISADataDetails } from '../../../shared/utils/api.utils';

const useISAInvestigationDetails = ({ investigationId }) => {

  console.log(" ddffff "  + investigationId) ;
  const [isaDataDetails, setISADataDetails] = useState<ISADataDetails[]>([]);

  const getDetails = useCallback(async () => {
    try {
      console.log(" Inside getDetails ")
      const isaDataDets = await getISADataDetails(investigationId);

      //setISADataDetails(isaDataDetails.concat(isaDataDets["mst"]));
      setISADataDetails(isaDataDets);
    } catch (error) {
      alert('Could not get ISA Data Details');
      console.log({ isaDataError: error });
      //onClose();
    }
  }, [investigationId]);

//}, [investigationId, onClose]);
  
  useEffect(() => {
    if (!investigationId) {
      alert('Invalid Investigation Id');
      //onClose();
    } else {
      console.log(" In GETTTTT")
      getDetails();
    }
  }, [investigationId,  getDetails]);
//}, [investigationId, onClose, getDetails]);

  return isaDataDetails["mst"];
};

export default useISAInvestigationDetails;
