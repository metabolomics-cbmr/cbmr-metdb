import React from 'react';
// import Card from '../../atoms/Card';
// import SearchBar from '../../atoms/SearchBar';


import MainLayout from '../../layouts/MainLayout';
import Header from '../../organisms/Header';
import DashboardSidebar from '../DashboardPage/components/DashboardSidebar';
// import { SectionTitle } from '../DashboardPage/Dashboard.style';
import './ISADataUploadPage.style.scss';
// import PgAdminLogo from '../../../../assets/images/pg-admin-logo.png';
// import LogsLogo from '../../../../assets/images/1024px-File_alt_font_awesome.svg.png';
// import styled from 'styled-components';
import API_URLS from '../../../shared/constants/api.const';
import ISADataUpload from './components/ISADataUpload';
import { useHistory } from'react-router' ;
import arrowLeft from '../../../../assets/images/arrow-left.svg';

// import ISADataListLayout from '../../organisms/ISADataInfo/components/ISADataListLayout';
import {ISADataList} from '../../organisms/ISADataInfo/ISADataList';
import { useState } from "react" ;


const ISAData =  ({onFileUpload}) => {


 
   const history = useHistory() ; 
  

    return (
    <div className="isa-page_inner">
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


      <ISADataUpload
        uploadUrl={API_URLS.UPLOAD_ISA}
        fileUploadTitle="Upload ISA Data Files" 
        onFileUpload = {onFileUpload}
      ></ISADataUpload>      


      <div className="mt-5"><ISADataList /></div>      

    </div>
  );
};
// const ISAData = () => {

//   return (
//     <div>Tttetetet</div>
//   )
// }


const ISADataUploadPage = (props) => {

  const [dateTime, setDateTime] = useState(new Date()) ;
  
  console.log(dateTime)

return (
<div >
    {<MainLayout sidebar={<DashboardSidebar />} content={<ISAData key={dateTime.getTime()} onFileUpload={setDateTime}  />} /> }
  </div>
);
}

export default ISADataUploadPage;
