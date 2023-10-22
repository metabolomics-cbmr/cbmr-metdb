import Button from '../../../atoms/Button';
import ModuleGradient from '../../../atoms/ModuleGradient';
import docIcon from '../../../../../assets/images/doc-icon.svg';

const Docs = (props) => (
  <div className="dashboard-docs">
    <ModuleGradient>
      <div className="dashboard-docs__inner">
        <img alt="" src={docIcon} />
        <br />
        <br />
        <div className="dashboard-docs__text">
          <strong>Need help?</strong>
          <br />
          Please Check our docs
        </div>
        <br />
        <Button>Documentation</Button>
      </div>
    </ModuleGradient>
  </div>
);

export default Docs;
