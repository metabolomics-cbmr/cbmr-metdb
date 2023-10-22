import Card from '../../../atoms/Card';
import BottomTip from './BottomTip';
import * as S from '../Dashboard.style';

const DasboardStatsCard = ({ title, count, bottomTipText, bottomTipClick }) => {
  return (
    <Card
      className="mb-4 dashboard__stats-card p-3 hoverable"
      onClick={bottomTipClick}
    >
      <S.DashboardStatsTileTitle>{title}</S.DashboardStatsTileTitle>
      <div className="dashboard-count">{count}</div>
      {bottomTipText && <BottomTip text={bottomTipText} />}
    </Card>
  );
};

export default DasboardStatsCard;
