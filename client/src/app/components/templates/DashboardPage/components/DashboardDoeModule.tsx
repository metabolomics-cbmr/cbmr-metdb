import { useEffect, useState } from 'react';
import { Col, Dropdown } from 'react-bootstrap';
import { useHistory } from 'react-router';
import { ROUTES } from '../../../../Routes';
import API_URLS from '../../../../shared/constants/api.const';
import DashboardModule from './DashboardModule';
import DataUploader from './DataUploader';
import useComparisonSettings from '../../../../shared/hooks/useComparisonSettings';
import Card from '../../../atoms/Card/Card';
import UnknownCompoundDetectionConfig from '../../Settings/Components/UnknownCompoundDetectionConfig/UnknownCompoundDetectionConfig';
import { ComparisionSettings } from '../../../../shared/model/comparision.model';

import { Method } from '../../../../shared/model/methods.model';
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



const SelectedConfig = ({
  selectedConfig,
}: {
  selectedConfig: ComparisionSettings;
}) => {
  const { name, config } = selectedConfig;
  const { matching_peaks, matching_score, pep_mass_tolerance } = config;
  return (
    <Card>
      <UnknownCompoundDetectionConfig
        comparisionSettings={{
          name,
          matching_peaks,
          matching_score,
          pep_mass_tolerance,
        }}
      />
    </Card>
  );
};

const ConfigDropDown = ({
  comparisionSettings,
  setSelectedConfig,
  selectedConfig,
}: {
  comparisionSettings: ComparisionSettings[];
  setSelectedConfig: any;
  selectedConfig: ComparisionSettings;
}) => {
  return (
    <Dropdown className="mb-3">
      <Dropdown.Toggle id="dropdown-basic">
        Select a Config: {selectedConfig.name}
      </Dropdown.Toggle>
      <Dropdown.Menu>
        {comparisionSettings.map((config) => (
          <Dropdown.Item onClick={() => setSelectedConfig(config)}>
            {config.name}
          </Dropdown.Item>
        ))}
      </Dropdown.Menu>
    </Dropdown>
  );
};

const DashboardDoeModule = () => {
  const [showUploadModal, setShowUploadModal] = useState(false);
  const history = useHistory();
  const uploadData = () => {
    setShowUploadModal(true);
  };

  // const navigateToDoe = () => {
  //   history.push(ROUTES.DOE);
  // };

  const displayResultsOfComparison = ({ resultid }) => {
    if (resultid) {
      history.push(ROUTES.RESULTS_RETRIEVAL.replace(':id', resultid));
    }
  };

  const { comparisionSettings } = useComparisonSettings();

  const [selectedConfig, setSelectedConfig] = useState(
    comparisionSettings?.[0],
  );

  useEffect(() => {
    setSelectedConfig(comparisionSettings[0]);
  }, [comparisionSettings]);

  const { methods } = useMethods();

  const [selectedMethod, setSelectedMethod] = useState(
    methods?.[0],
  );

  useEffect(() => {
    setSelectedMethod(methods[0]);
  }, [methods]);



  return (
    <>
      <Col sm={12} md={12} lg={6} xl={6} key={1}>
        <DashboardModule
          index={1}
          title="Compare"
          description="Click here to run a new Comparision. <br/>Once your Comparison has been processed, <br/> you will be redirected to the results. <br/>You can also come back to the result <br/> by clicking on View Results."
          onClick={uploadData}
          tooltipId="comparison_tooltip"
          bottomControls={
            <>
              {/* <div className="mb-3">
                <BottomTip text="New Comparison" onClick={uploadData} />
              </div>
              <BottomTip text="Design New Experiment" onClick={navigateToDoe} /> */}
            </>
          }
          moduleImage="Run a New Comparision"
        />
      </Col>
      {showUploadModal ? (
        <DataUploader
          fileKey="file"
          uploadUrl={API_URLS.UPLOAD_UNKNOWN_COMPOUNDS}
          hideModal={() => setShowUploadModal(false)}
          onFileUpload={displayResultsOfComparison}
          title="Upload File for a New Comparison"
          isSaveButtonEnabled={!!selectedConfig}
          additionalUploadData={{ config: selectedConfig.id , method: selectedMethod.id }}
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


          <>
            <div className="border-bottom my-3" />
            <h6>
              Which Configuration Would you like to apply to this Comparison?
            </h6>
            <ConfigDropDown
              comparisionSettings={comparisionSettings}
              setSelectedConfig={setSelectedConfig}
              selectedConfig={selectedConfig}
            />
            <SelectedConfig selectedConfig={selectedConfig} />
          </>
        </DataUploader>
      ) : null}
    </>
  );
};

export default DashboardDoeModule;
