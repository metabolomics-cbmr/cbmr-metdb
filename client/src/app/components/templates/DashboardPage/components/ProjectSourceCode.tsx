import React from 'react';
import Card from '../../../atoms/Card';
import ModuleGradient from '../../../atoms/ModuleGradient';
import { SectionTitle } from '../Dashboard.style';
import codeIcon from '../../../../../assets/images/code-icon.svg';
import BottomTip from './BottomTip';

const ProjectSourceCode = () => {
  return (
    <React.Fragment>
      <SectionTitle>Project Source Code</SectionTitle>
      <Card className="project-source-code">
        <ModuleGradient className="project-source-code__left">
          <img alt="" src={codeIcon} />
        </ModuleGradient>
        <div className="project-source-code__right">
          <p className="dashboard-module__title">Source Code</p>
          <p className="dashboard-module__subtitle">Link to our GitHub Repo</p>
          <BottomTip text="View Source Code" />
        </div>
      </Card>
    </React.Fragment>
  );
};

export default ProjectSourceCode;
