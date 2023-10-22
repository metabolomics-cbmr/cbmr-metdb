import { useState, useCallback, useEffect } from 'react';
import { MS2FileDetails } from '../../../shared/model/ms2file-details.model';
import { getMS2FileDetails } from '../../../shared/utils/api.utils';

const useMS2FileInfo = ({ ms2FileId, onClose }) => {
  const [ms2FileDetails, setMS2FileDetails] = useState<MS2FileDetails>();

  const getDetails = useCallback(async () => {
    try {
      const ms2FileDetailsAPI = await getMS2FileDetails(ms2FileId);
      setMS2FileDetails(ms2FileDetailsAPI);
    } catch (error) {
      alert('Could not get MS2 File Details');
      console.log({ ms2Error: error });
      onClose();
    }
  }, [ms2FileId, onClose]);

  useEffect(() => {
    if (!ms2FileId) {
      alert('Invalid File');
      onClose();
    } else {
      getDetails();
    }
  }, [ms2FileId, onClose, getDetails]);

  return ms2FileDetails;
};

export default useMS2FileInfo;
