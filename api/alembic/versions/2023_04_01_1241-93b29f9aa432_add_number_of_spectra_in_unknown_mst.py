"""Add number of spectra in unknown mst

Revision ID: 93b29f9aa432
Revises: 81503ebcd8f2
Create Date: 2023-04-01 12:41:16.526493

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '93b29f9aa432'
down_revision = '81503ebcd8f2'
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.add_column('UnknownMS2Mst', sa.Column('num_spectra_in_file', sa.Integer))
    #op.alter_column('UnknownMS2Mst', 'num_spectra_in_file', nullable=False)


def downgrade() -> None:
    pass
