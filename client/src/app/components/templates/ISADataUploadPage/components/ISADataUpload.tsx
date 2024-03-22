import { useState } from 'react';
import ISADataUploader from './ISADataUploader';

const ISADataUpload = ({
  uploadUrl,
  fileUploadTitle, 
  onFileUpload
}) => {
  const [showUploadModal, setShowUploadModal] = useState(false);
  const uploadData = () => {
    setShowUploadModal(true);
  };
  return (
    <>
      {/* <tr className="border-bottom">
        <td className="px-3 pt-4 pb-5"> */}
          <div  onClick={uploadData}>
            <u>Upload ISA Data</u>
          </div>
        {/* </td>
      </tr> */}
      {showUploadModal && uploadUrl ? (
        <ISADataUploader
          fileKey="file"
          uploadUrl={uploadUrl}
          hideModal={() => setShowUploadModal(false)}
          title={fileUploadTitle} 
          onFileUpload={onFileUpload}
        />
      ) : null}
    </>
  );
};

export default ISADataUpload;
