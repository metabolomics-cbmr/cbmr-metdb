import { useState } from 'react';
import { uploadFile } from '../../../../shared/utils/api.utils';
import FileUploader from '../../../organisms/FileUploader';
import ModalWrapper from '../../../organisms/ModalWrapper';

const DataUploader = ({
  fileKey,
  uploadUrl,
  hideModal,
  onFileUpload,
  title = 'Upload Data',
  additionalUploadData = {},
  children = null,
  isSaveButtonEnabled = true,
}: {
  fileKey: string;
  uploadUrl: string;
  hideModal: any;
  onFileUpload: any;
  title?: string;
  additionalUploadData?: any;
  children?: any;
  isSaveButtonEnabled?: boolean;
}) => {
  const [fileToUpload, setFileToUpload] = useState(null);
  const [isUploading, setIsUploading] = useState(false);
  const [saveButtonText, setSaveButtonText] = useState('Save');
  const uploadDataFile = async () => {
    if (fileToUpload) {
      try {
        setIsUploading(true);
        setSaveButtonText('Uploading...');
        const result = await uploadFile(
          uploadUrl,
          fileKey,
          fileToUpload,
          additionalUploadData,
        );
        hideModal();
        onFileUpload(result);
      } catch (error: any) {
        console.log({ fileUploadError: error });
        const { body } = JSON.parse(`${error?.message}`);
        const alertMessage =
          body?.description || 'Error: We could not upload the file.';
        alert(alertMessage);
      } finally {
        setIsUploading(false);
        setSaveButtonText('Save');
      }
    }
  };
  return (
    <ModalWrapper
      title={title}
      onClickSave={uploadDataFile}
      open={true}
      onCancel={hideModal}
      isSaveEnabled={!!fileToUpload && !isUploading && isSaveButtonEnabled}
      saveButtonText={saveButtonText}
    >
      <FileUploader
        title="Upload File"
        placeholder="Choose File"
        onFileSelect={setFileToUpload}
      />
      {children}
    </ModalWrapper>
  );
};

export default DataUploader;
