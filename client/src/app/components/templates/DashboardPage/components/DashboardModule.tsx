import { Link } from 'react-router-dom';
import Card from '../../../atoms/Card';
import ModuleGradient from '../../../atoms/ModuleGradient';
import Tooltip from '../../../atoms/Tooltip';
import InformationImage from '../../../../../assets/images/information_small.png';

const DashboardModule = (props: {
  href?: string;
  title: string;
  description: string;
  index: number;
  moduleImage: any;
  bottomControls: any;
  onClick?: any;
  tooltipId:string
}) => {
  const {
    index,
    href,
    title,
    description,
    bottomControls,
    moduleImage,
    onClick,
    tooltipId,
  } = props;
  const LinkWrapper = ({ children }) =>
    href ? (
      <Link to={href} key={index}>
        {children}
      </Link>
    ) : (
      <>{children}</>
    );
  return (
    <LinkWrapper>
      <Card className="dashboard-module" key={index} onClick={onClick}>
        <div className="dashboard-module__left">
          <p className="dashboard-module__title">{title} &nbsp;
          {/* <p className="dashboard-module__subtitle">{description}</p> */}
          <Tooltip content={description} id={tooltipId}>
            <img src={InformationImage} alt="Information"></img>

          </Tooltip>
          </p>
          {bottomControls}
        </div>
        <ModuleGradient className="dashboard-module__right text-center">
          {moduleImage}
        </ModuleGradient>
      </Card>
    </LinkWrapper>
  );
};

export default DashboardModule;
