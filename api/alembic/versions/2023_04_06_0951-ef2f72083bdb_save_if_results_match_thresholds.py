"""Save if results match thresholds

Revision ID: ef2f72083bdb
Revises: 06538ebaaaaf
Create Date: 2023-04-06 09:51:30.987686

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'ef2f72083bdb'
down_revision = '06538ebaaaaf'
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.add_column('UnknownDetectionResults', sa.Column('over_threshold', sa.Boolean))
    op.alter_column('UnknownDetectionResults', 'over_threshold', nullable=True)


def downgrade() -> None:
    pass
