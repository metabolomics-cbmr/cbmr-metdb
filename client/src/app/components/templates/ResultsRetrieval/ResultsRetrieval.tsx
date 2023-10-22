import { useCallback, useEffect, useState } from 'react';
import { Button, Col, Row } from 'react-bootstrap';
import { useHistory, useParams } from 'react-router';
import { BASE_URL } from '../../../shared/constants/api.const';
import {
  DEFAULT_UNKNOWN_COMPOUND_DETECTION_RESULT,
  UNKNOWN_COMPOUND_REFERENCE_KEYS,
  UNKNOWN_COMPOUND_DESCRIPTION_ORDER,
  UNKNOWN_COMPOUND_DETECTION_SUMMARY,
} from '../../../shared/constants/unknown-compound-detection.const';
import {
  Query,
  UnknownCompoundDetectionAPIResult,
} from '../../../shared/model/unknown-compound-detection.model';
import {
  exportUnknownCompoundDetectionToExcel,
  getUnknownCompoundDetectionDetails,
} from '../../../shared/utils/api.utils';
import Card from '../../atoms/Card';
import MainLayout from '../../layouts/MainLayout';
import Header from '../../organisms/Header';
import DashboardSidebar from '../DashboardPage/components/DashboardSidebar';
import { SectionTitle } from '../DashboardPage/Dashboard.style';
import './ResultsRetrieval.style.scss';
import arrowLeft from '../../../../assets/images/arrow-left.svg';
import { ROUTES } from '../../../Routes';
import Form from 'react-bootstrap/Form';
import Loader from '../../atoms/Loader/Loader';
import ExcelGraph from '../../../../assets/images/excel_graph.svg';

const Settings = ({
  detectionResult,
}: {
  detectionResult: UnknownCompoundDetectionAPIResult;
}) => {
  return (
    <div className="d-flex flex-wrap">
      <div className="d-flex justify-content-between w-100 mb-3">
        <span className="table-header-text">Settings</span>
      </div>
      <Card className="p-0 w-100">
        <table className="w-100">
          <thead>
            <tr className="border-bottom">
              <th className="p-3">Description</th>
              <th className="p-3">Threshold</th>
            </tr>
          </thead>
          <tbody>
            {Object.values(detectionResult?.settings).map((setting) => (
              <tr className="border-bottom table__row--hoverable">
                <td className="p-3 table-text">{setting.description}</td>
                <td className="p-3 table-text">{setting.threshold}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </Card>
    </div>
  );
};

const Summary = ({
  detectionResult,
}: {
  detectionResult: UnknownCompoundDetectionAPIResult;
}) => {
  return (
    <div className="d-flex flex-wrap">
      <div className="d-flex justify-content-between w-100 mb-3">
        <span className="table-header-text">Summary</span>
      </div>
      <Card className="p-0 w-100">
        <table className="w-100">
          <thead>
            <tr className="border-bottom">
              <th className="p-3">Description</th>
              <th className="p-3">Value</th>
            </tr>
          </thead>
          <tbody>
            {Object.entries(detectionResult?.summary).map(
              ([description, value]) => (
                <tr className="border-bottom table__row--hoverable">
                  <td className="p-3 table-text">
                    {UNKNOWN_COMPOUND_DETECTION_SUMMARY[description]}
                  </td>
                  <td className="p-3 table-text">{value}</td>
                </tr>
              ),
            )}
          </tbody>
        </table>
      </Card>
    </div>
  );
};

const TopRow = ({
  detectionResult,
}: {
  detectionResult: UnknownCompoundDetectionAPIResult;
}) => {
  return (
    <Row>
      <Col>
        <Settings detectionResult={detectionResult} />
      </Col>
      <Col>
        <Summary detectionResult={detectionResult} />
      </Col>
    </Row>
  );
};

// const Output = ({
//   detectionResult,
// }: {
//   detectionResult: UnknownCompoundDetectionAPIResult;
// }) => {
//   return <Card className='p-5'>
//     <div className="d-flex justify-content-between w-100 mb-3">
//         <span className="table-header-text">Output</span>
//       </div>

//     {detectionResult.output.map(outputRow => {
//     return <Collapsible trigger={outputRow.data.reference.name} hasBorder></Collapsible>
//   })}
//   </Card>
// }

const Compound = ({ compound, title }: { compound: Query; title: string }) => (
  <>
    {UNKNOWN_COMPOUND_DESCRIPTION_ORDER.map(
      (key, index) =>
        compound?.[key] && (
          <tr>
            {index === 0 && (
              <th
                scope="row"
                rowSpan={UNKNOWN_COMPOUND_DESCRIPTION_ORDER.length}
              >
                {title}
              </th>
            )}

            <th scope="row">{UNKNOWN_COMPOUND_REFERENCE_KEYS[key]}</th>
            <td className="text-right">{compound?.[key]}</td>
          </tr>
        ),
    )}
  </>
);

const OutputCard = ({
  detectionResult,
  id,
}: {
  detectionResult: UnknownCompoundDetectionAPIResult;
  id: string;
}) => {
  return (
    <div className="d-flex flex-wrap mt-3">
      <div className="d-flex justify-content-between w-100 mb-3">
        <span className="table-header-text">Output</span>
      </div>
      <p>
        <span className="text-secondary font-weight-bold">Comparison Id: </span>
        <span className="text-info font-weight-bold">{id}</span>
      </p>
      <Card className="p-0 w-100">
        <table className="w-100">
          <thead>
            <tr className="border-bottom">
              <th className="p-3 text-center">Sr. No.</th>
              <th className="p-3">Description</th>
              <th className="p-3">Spectrum Comparison</th>
              <th className="p-3">Molecular Structure</th>
            </tr>
          </thead>
          <tbody>
            {Object.values(detectionResult?.output).map((outputRow, index) => (
              <tr className="border-bottom">
                <td className="p-3 text-center table-text">{index + 1}</td>
                <td className="p-3 table-text">
                  <table className="table">
                    <tbody>
                      <Compound
                        title="Reference Compound (Spectrum 1)"
                        compound={outputRow.data.reference}
                      />
                      <Compound
                        title="Query Compound (Spectrum 2 )"
                        compound={outputRow.data.query}
                      />
                      <tr>
                        <th scope="row">Similarity Function</th>
                        <td className="text-right">
                          {outputRow.data.result.match_method}
                        </td>
                      </tr>
                      <tr>
                        <th scope="row">Number of Matching Peaks</th>
                        <td colSpan={2}>
                          {outputRow.data.result.num_matching_peaks}
                        </td>
                      </tr>
                      <tr>
                        <th scope="row">Score</th>
                        <td colSpan={2}>{outputRow.data.result.score}</td>
                      </tr>
                    </tbody>
                  </table>
                </td>
                <td className="p-3 table-text">
                  <img
                    alt="mz_intensity"
                    className="w-100"
                    src={`${BASE_URL}${outputRow.data.image.mz_intensity}`}
                  />
                </td>
                <td className="p-3 table-text">
                  <img
                    alt="molecular_structure"
                    className="w-100"
                    src={`${BASE_URL}${outputRow.data.image.molecular_structure}`}
                  />
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </Card>
    </div>
  );
};

const UnknownCompoundDetectionResults = () => {
  const { id } = useParams<any>();
  const [detectionResult, setDetectionResult] =
    useState<UnknownCompoundDetectionAPIResult>(
      DEFAULT_UNKNOWN_COMPOUND_DETECTION_RESULT,
    );
  const [loading, setLoading] = useState(false);
  const [displayMatchingResults, setDisplayMatchingResults] = useState(false);
  const history = useHistory();
  const getResults = useCallback(
    async (id) => {
      try {
        setLoading(true);
        const result = await getUnknownCompoundDetectionDetails(
          id,
          displayMatchingResults,
        );
        setDetectionResult(result);
      } catch (error) {
        console.log('getUnknownCompoundDetectionDetails ERROR', { error });
        alert('Could not get Unknown Compound Detection Results');
      } finally {
        setLoading(false);
      }
    },
    [displayMatchingResults],
  );

  const handleExportDataToExcel = () => {
    exportUnknownCompoundDetectionToExcel(id, displayMatchingResults);
  };

  useEffect(() => {
    if (!id) {
      alert('Please specify which result');
      history.push(ROUTES.RESULTS);
    } else {
      getResults(id);
    }
  }, [history, id, getResults]);

  return (
    <>
      {loading ? <Loader /> : null}
      <Header
        pageTitle={
          <>
            <img
              className="arrow-left mr-2"
              src={arrowLeft}
              alt=""
              onClick={history.goBack}
            />
            Metabolomics
          </>
        }
      />
      <SectionTitle>Unknown Compound Detection</SectionTitle>
      <TopRow detectionResult={detectionResult} />
      {/* Filter results by the configuration threshold */}
      <div className="border rounded py-2 px-5 bg-light my-5">
        <Form.Check
          type="switch"
          label={
            <span className="font-weight-bold text-muted">
              Only Display Results that match the configuration threshold
            </span>
          }
          onChange={(event) => {
            setDisplayMatchingResults(event.target.checked);
          }}
        />
      </div>
      {/* Export Comparison Results to Excel */}
      <div className="border rounded py-2 px-5 bg-light my-5 d-flex flex-row align-items-center justify-content-between">
        <div className="d-flex flex-row align-items-center ">
          <img alt="excelGraph" src={ExcelGraph} style={{ height: '75px' }} />
          <h6 className="text-muted mx-4 my-2">
            Want to Analyze these results? <br />
            Get these results in Excel.
          </h6>
        </div>
        <Button onClick={handleExportDataToExcel}>Export To Excel</Button>
      </div>

      <OutputCard detectionResult={detectionResult} id={id} />
    </>
  );
};

const ResultsRetrieval = (props) => {
  return (
    <div className="results-retrieval-page">
      <MainLayout
        sidebar={<DashboardSidebar />}
        content={<UnknownCompoundDetectionResults />}
      />
    </div>
  );
};

export default ResultsRetrieval;
