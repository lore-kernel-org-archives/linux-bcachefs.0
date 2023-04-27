Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 633E9C77B73
	for <linux-bcachefs@archiver.kernel.org>; Thu, 27 Apr 2023 06:44:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242672AbjD0GoA (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 27 Apr 2023 02:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242586AbjD0Gn7 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 27 Apr 2023 02:43:59 -0400
Received: from relay-b03.edpnet.be (relay-b03.edpnet.be [212.71.1.220])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C95EB1FEC
        for <linux-bcachefs@vger.kernel.org>; Wed, 26 Apr 2023 23:43:57 -0700 (PDT)
X-ASG-Debug-ID: 1682577835-15c4354f81152ab30001-qsCQDO
Received: from linuxserver.costadelsollie.local (213.219.188.14.adsl.dyn.edpnet.net [213.219.188.14]) by relay-b03.edpnet.be with ESMTP id A9mZ0U8TbuAsShSm; Thu, 27 Apr 2023 08:43:55 +0200 (CEST)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 213.219.188.14.adsl.dyn.edpnet.net[213.219.188.14]
X-Barracuda-Apparent-Source-IP: 213.219.188.14
From:   Janpieter Sollie <janpieter.sollie@kabelmail.de>
To:     linux-bcachefs@vger.kernel.org
Cc:     Janpieter Sollie <janpieter.sollie@edpnet.be>,
        Janpieter Sollie <janpieter.sollie@kabelmail.de>
Subject: [PATCH] add --data_types for bcachefs device add
Date:   Thu, 27 Apr 2023 08:43:55 +0200
X-ASG-Orig-Subj: [PATCH] add --data_types for bcachefs device add
Message-Id: <20230427064355.5994-1-janpieter.sollie@kabelmail.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <ZEk4RA1Vwy8ua3JP@moria.home.lan>
References: <ZEk4RA1Vwy8ua3JP@moria.home.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: 213.219.188.14.adsl.dyn.edpnet.net[213.219.188.14]
X-Barracuda-Start-Time: 1682577835
X-Barracuda-URL: https://212.71.1.220:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 3208
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.107989
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

From: Janpieter Sollie <janpieter.sollie@edpnet.be>

bcachefs format allows to specify data types allowed on a specific device,
this is not available when adding a device with bcachefs device add.
The patch adds this functionality.  It is kept as minimal as possible,
the device specific OPTS from cmd_format should be imported
instead of specifying them a 2nd time here

Signed-off-by: Janpieter Sollie <janpieter.sollie@kabelmail.de>
---
 cmd_device.c  |  7 +++++++
 cmd_format.c  | 10 ----------
 libbcachefs.h | 10 ++++++++++
 3 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/cmd_device.c b/cmd_device.c
index c59d370..4a296a1 100644
--- a/cmd_device.c
+++ b/cmd_device.c
@@ -51,6 +51,7 @@ static void device_add_usage(void)
 	     "  -B, --bucket=size           Bucket size\n"
 	     "  -D, --discard               Enable discards\n"
 	     "  -l, --label=label           Disk label\n"
+	     "  -a, --data_allowed=types    allowed data on this device\n"
 	     "  -f, --force                 Use device even if it appears to already be formatted\n"
 	     "  -h, --help                  Display this help and exit\n"
 	     "\n"
@@ -64,6 +65,7 @@ int cmd_device_add(int argc, char *argv[])
 		{ "bucket",		required_argument,	NULL, 'B' },
 		{ "discard",		no_argument,		NULL, 'D' },
 		{ "label",		required_argument,	NULL, 'l' },
+		{ "data_allowed",	required_argument,	NULL, 'a' },
 		{ "force",		no_argument,		NULL, 'f' },
 		{ "help",		no_argument,		NULL, 'h' },
 		{ NULL }
@@ -90,6 +92,11 @@ int cmd_device_add(int argc, char *argv[])
 		case 'l':
 			dev_opts.label = strdup(optarg);
 			break;
+                case 'a':
+                        dev_opts.data_allowed =
+                                read_flag_list_or_die(optarg,
+                                        bch2_data_types, "data type");
+                        break;
 		case 'f':
 			force = true;
 			break;
diff --git a/cmd_format.c b/cmd_format.c
index 26a1cd9..3401570 100644
--- a/cmd_format.c
+++ b/cmd_format.c
@@ -102,16 +102,6 @@ static const struct option format_opts[] = {
 };
 #undef x
 
-u64 read_flag_list_or_die(char *opt, const char * const list[],
-			  const char *msg)
-{
-	u64 v = bch2_read_flag_list(opt, list);
-	if (v == (u64) -1)
-		die("Bad %s %s", msg, opt);
-
-	return v;
-}
-
 int cmd_format(int argc, char *argv[])
 {
 	DARRAY(struct dev_opts) devices = { 0 };
diff --git a/libbcachefs.h b/libbcachefs.h
index 4bb51bd..de92f82 100644
--- a/libbcachefs.h
+++ b/libbcachefs.h
@@ -98,6 +98,16 @@ struct bchfs_handle bcache_fs_open(const char *);
 struct bchfs_handle bchu_fs_open_by_dev(const char *, int *);
 int bchu_dev_path_to_idx(struct bchfs_handle, const char *);
 
+static inline u64 read_flag_list_or_die(char *opt, const char * const list[],
+                          const char *msg)
+{
+        u64 v = bch2_read_flag_list(opt, list);
+        if (v == (u64) -1)
+                die("Bad %s %s", msg, opt);
+
+        return v;
+}
+
 static inline void bchu_disk_add(struct bchfs_handle fs, char *dev)
 {
 	struct bch_ioctl_disk i = { .dev = (unsigned long) dev, };
-- 
2.39.1

