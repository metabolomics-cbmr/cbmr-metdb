import ModalWrapper from '../ModalWrapper';
import Ms2FileDetailsLayout from './components/MS2FileDetailsLayout';
import useMS2FileInfo from './useMS2FileInfo.hook';
import LazyCollapsible from '../../atoms/LazyCollapsible';
import MS2FileCompoundLayout from './components/MS2FileCompoundLayout';

const MS2FileInfo = ({ ms2FileId, onClose }) => {
  const ms2FileDetails = useMS2FileInfo({ ms2FileId, onClose });
  const ms2FileCompounds = ms2FileDetails?.dets[0] || [];
  return (
    <ModalWrapper
      title="Imported MS2 File Details"
      closeButtonText="Close"
      onCancel={onClose}
    >
      <Ms2FileDetailsLayout ms2FileDetails={ms2FileDetails} />
      <LazyCollapsible
        trigger={<span className="table-header-text">Compound Scans</span>}
        hasBorder
      >
        {ms2FileCompounds?.map((ms2FileCompoundShort) => (
          <MS2FileCompoundLayout ms2FileCompoundShort={ms2FileCompoundShort} />
        ))}
      </LazyCollapsible>
    </ModalWrapper>
  );
};

export default MS2FileInfo;
