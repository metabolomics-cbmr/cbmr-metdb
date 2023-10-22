import { useState } from 'react';
import {
  MS2FileCompoundShortObject,
  MS2FileCompound,
} from '../../../../shared/model/ms2file-details.model';
import { getMS2FileCompoundDetails } from '../../../../shared/utils/api.utils';
import Collapsible from '../../../atoms/Collapsible';
import MS2CompoundPeaks from './MS2CompoundPeaks';
import MS2CompoundScanDetails from './MS2CompoundScanDetails';

const MS2FileCompoundLayout = ({
  ms2FileCompoundShort,
}: {
  ms2FileCompoundShort: MS2FileCompoundShortObject;
}) => {
  const [ms2FileCompound, setMs2FileCompound] = useState<MS2FileCompound>();
  const getMS2FileCompound = async () => {
    try {
      if (!ms2FileCompound) {
        const result = await getMS2FileCompoundDetails(
          ms2FileCompoundShort?.id,
        );
        const [compoundDetails] = result?.dets || [];
        setMs2FileCompound(compoundDetails);
      }
    } catch (error) {
      alert('Could not get the MS2 File Compound');
      console.log('Could not get the MS2 File Compound', { error });
    }
  };
  return (
    <Collapsible
      trigger={
        <div className="table-header-text">
          Scan Number: {ms2FileCompoundShort?.spec_scan_num}
        </div>
      }
      onOpen={getMS2FileCompound}
    >
      {ms2FileCompound ? (
        <>
          <MS2CompoundScanDetails ms2FileCompound={ms2FileCompound} />
          <MS2CompoundPeaks peaks={ms2FileCompound?.peaks} />
        </>
      ) : (
        <p>Getting Scanned Compound...</p>
      )}
    </Collapsible>
  );
};

export default MS2FileCompoundLayout;
