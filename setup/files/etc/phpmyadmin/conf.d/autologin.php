<?php

$cfg['Servers'][$i]['auth_type'] = 'config';
$cfg['Servers'][$i]['user'] = 'root';
$cfg['Servers'][$i]['password'] = 'root';
$cfg['Servers'][$i]['AllowDeny']['order'] = 'deny,allow';
$cfg['Servers'][$i]['AllowDeny']['rules'] = array(
'deny root from all',
'allow root from 10.10.10.1',
);