"""config activate and audit

Revision ID: d646a0ca43d3
Revises: ef2f72083bdb
Create Date: 2023-05-10 16:44:20.072235

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'd646a0ca43d3'
down_revision = 'ef2f72083bdb'
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.add_column('Configs', sa.Column('active', sa.Boolean))
    op.add_column('Configs', sa.Column('created_by', sa.Integer))
    op.add_column('Configs', sa.Column('created_on', sa.DateTime, server_default = sa.func.current_timestamp()))
    op.add_column('Configs', sa.Column('updated_by', sa.Integer))
    op.add_column('Configs', sa.Column('updated_on', sa.DateTime, server_default = sa.func.current_timestamp()))



def downgrade() -> None:
    pass
