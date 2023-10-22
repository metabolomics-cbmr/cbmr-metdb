import React from 'react';
import MainLayoutContainer from '../../layouts/MainLayout';
import Header from '../../organisms/Header';
import './InvestigationForm.style.scss';
import InvestigationFormContent from './Components/InvestigationFormContent';
import InvestigationFormContextProvider from './Components/InvestigationFormContext';
import InvestigationFormSidebar from './Components/InvestigationFormSidebar';

const InvestigationForm = () => {
  return (
    <React.Fragment>
      <Header pageTitle="Design of Experiment" />
      <InvestigationFormContent />
    </React.Fragment>
  );
};

class InvestigationFormPage extends React.Component {
  render() {
    return (
      <InvestigationFormContextProvider>
        <MainLayoutContainer
          sidebar={<InvestigationFormSidebar />}
          content={<InvestigationForm />}
        />
      </InvestigationFormContextProvider>
    );
  }
}

export default InvestigationFormPage;
