import Card from '../../../../atoms/Card';
import InvestigationFormGeneral from '../InvestigationFormGeneral';
import InvestigationFormStudies from '../InvestigationFormStudies';
import backIcon from '../../../../../../assets/images/back-icon.svg';
import { Link } from 'react-router-dom';
import { ROUTES } from '../../../../../Routes';

const InvestigationFormContent = () => {
  return (
    <div className="investigation-form">
      <Card>
        <div className="investigation-form__inner">
          <h3 className="form-title">
            <Link to={ROUTES.DASHBOARD}>
              <img src={backIcon} alt="" className="back-icon" />
            </Link>
            Investigation
          </h3>
          <InvestigationFormGeneral />
          <InvestigationFormStudies />
        </div>
        <div className="card__footer">
          <Link to={ROUTES.DASHBOARD}>
            <button className="btn--flat">Cancel</button>
          </Link>
          <button className="btn--primary float--right">Submit</button>
        </div>
      </Card>
    </div>
  );
};

export default InvestigationFormContent;
