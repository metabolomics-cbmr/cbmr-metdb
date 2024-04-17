import { useState, useEffect } from 'react';
import { DashboardStatsTileTitle } from '../Dashboard.style';
import BottomTip from './BottomTip';
import DataUploader from './DataUploader';
import { Method } from '../../../../shared/model/methods.model';
import { Dropdown } from 'react-bootstrap';
import useMethods from '../../../../shared/hooks/useMethods';

const MethodDropDown = ({
  methods,
  setSelectedMethod,
  selectedMethod,
}: {
  methods: Method[];
  setSelectedMethod: any;
  selectedMethod: Method;
}) => {
  return (
    <Dropdown className="mb-3">
      <Dropdown.Toggle id="dropdown-basic">
        Select a method: {selectedMethod.name}
      </Dropdown.Toggle>
      <Dropdown.Menu>
        {methods.map((method) => (
          <Dropdown.Item onClick={() => setSelectedMethod(method)}>
            {method.name}
          </Dropdown.Item>
        ))}
      </Dropdown.Menu>
    </Dropdown>
  );
};



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


  const { methods } = useMethods();

  const [selectedMethod, setSelectedMethod] = useState(
    methods?.[0],
  );

  useEffect(() => {
    setSelectedMethod(methods[0]);
  }, [methods]);


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
          isSaveButtonEnabled={!!selectedMethod}
          additionalUploadData={{ method: selectedMethod.id }}
        >
          <>
            <div className="border-bottom my-3" />
            <h6>
              Which method Would you like to apply to this upload?
            </h6>
            <MethodDropDown
              methods={methods}
              setSelectedMethod={setSelectedMethod}
              selectedMethod={selectedMethod}
            />

          </>



        </DataUploader>






        
      ) : null}
    </>
  );
};

export default DashboardStatsUpload;
