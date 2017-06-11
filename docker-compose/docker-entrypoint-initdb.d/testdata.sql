USE mail;
INSERT INTO mail_virtual_domains (name)
  VALUES
  ( 'test.com' );

INSERT INTO mail_virtual_users (domain_id, user, password)
  VALUES
  ( 1, 'root@test.com', '{SHA512-CRYPT}$6$QSqp4B9xWuDOAWgZ$oPD2YAMC3UWPm.uLafUIp0k8jf/gB6WXfPMfuS70btfLNU1e.Sn4fQoCSYCdrBJXOT1qs/d2nUW8cFR1zd73r0' );
