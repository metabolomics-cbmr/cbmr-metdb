
// import Ms2FileDetailsLayout from './components/MS2FileDetailsLayout';
// import useMS2FileInfo from './useMS2FileInfo.hook';
// import LazyCollapsible from '../../atoms/LazyCollapsible';
// import {ISADetailsLayout} from './components/MS2FileCompoundLayout';
import { useHistory, useParams } from "react-router" ;
import { useEffect } from "react" ;
import { ROUTES } from '../../../Routes';
import Header from '../../organisms/Header';
import { SectionTitle } from '../DashboardPage/Dashboard.style';
import MainLayout from '../../layouts/MainLayout';
import DashboardSidebar from '../DashboardPage/components/DashboardSidebar';
import InvestigationData from './components/InvestigationData' ;


const RecordNotFound = () => (
    <>
      <Header pageTitle="Metabolomics" />
      <SectionTitle>No Page found for that record</SectionTitle>
    </>
  );
  

const ISADataInvestigation = () => {

    const { id } = useParams<any>() ;


    console.log("Param passed " + id)
    const history = useHistory();

    const isInvestigationIdValid = id;

    useEffect(() => {
      if (!isInvestigationIdValid) {
        alert('Please specify investigation');
        history.push(ROUTES.ISADATA);
      }
    }, [isInvestigationIdValid, history]);
  
    return (
      (isInvestigationIdValid && <InvestigationData investigationId={id} />) || (
        <RecordNotFound />
      )
      




    );
  };
  
  const ISADataRetrieval = (props) => {
    return (
      <div className="records-page">
        <MainLayout sidebar={<DashboardSidebar />} content={<ISADataInvestigation />} />
      </div>
    );
  };


export default ISADataRetrieval ;