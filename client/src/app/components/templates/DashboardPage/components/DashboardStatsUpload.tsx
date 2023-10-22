import { useState } from 'react';
import { DashboardStatsTileTitle } from '../Dashboard.style';
import BottomTip from './BottomTip';
import DataUploader from './DataUploader';

const DashboardStatsUpload = ({
  title,
  count,
  uploadUrl,
  onFileUpload,
  fileUploadTitle,
}) => {
  const [showUploadModal, setShowUploadModal] = useState(false);
  const uploadData = () => {
    setShowUploadModal(true);
  };
  return (
    <>
      <tr className="border-bottom">
        <td className="px-3 pt-4 pb-5">
          <DashboardStatsTileTitle>{title}</DashboardStatsTileTitle>
          <div className="dashboard-count">{count}</div>
          <BottomTip text="Upload Data" onClick={uploadData} />
        </td>
      </tr>
      {showUploadModal && uploadUrl ? (
        <DataUploader
          fileKey="file"
          uploadUrl={uploadUrl}
          hideModal={() => setShowUploadModal(false)}
          onFileUpload={onFileUpload}
          title={fileUploadTitle}
        />
      ) : null}
    </>
  );
};

export default DashboardStatsUpload;
