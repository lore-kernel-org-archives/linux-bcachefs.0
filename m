Received: from mail.tintel.eu (mail.tintel.eu [51.83.127.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D2F2F5313
	for <linux-bcachefs@vger.kernel.org>; Tue,  2 Dec 2025 04:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.83.127.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764649051; cv=none; b=I4BlBIiCOngUYPr4b1BG+qGVvP3aAT5deRZZSvvWF6RfYGSuAOMxf+0hClCnnsCN4lwmOhwBWBV0QUJ/KgcxDpfbeVXIbflDsu03Of4K9tdw5Ew2QcyyYIA1e/GlDlF3DJVZewZ8Zin0pg+08yKUl8OAQ97GcoAorgmUssY4nsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764649051; c=relaxed/simple;
	bh=iUfV/wHgEExEImny5eSGbUT48+/9eHz6OuHlDY2OAsI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=JTAUi1KLnXIrcLirxSAB+G9R1eGQo4IKOImj/BsT0zg1qjR0OQDJWnw3zbGVrwQoNjBHqfTZcq1hZpAbbVI13aSy5jmMAFmYYZcB5mg8wHhDrOODdPGoAHpe3gPJcApTANhnxTtwqekDyXS2Ewf4gK4eogTjij+2wbmuZxHWlZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux-ipv6.be; spf=pass smtp.mailfrom=linux-ipv6.be; dkim=pass (1024-bit key) header.d=linux-ipv6.be header.i=@linux-ipv6.be header.b=o53zBeiX; arc=none smtp.client-ip=51.83.127.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux-ipv6.be
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux-ipv6.be
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-ipv6.be header.i=@linux-ipv6.be header.b="o53zBeiX"
Received: from localhost (localhost [IPv6:::1])
	by mail.tintel.eu (Postfix) with ESMTP id 2AF2C434DE6B
	for <linux-bcachefs@vger.kernel.org>; Tue,  2 Dec 2025 05:07:32 +0100 (CET)
Received: from mail.tintel.eu ([IPv6:::1])
 by localhost (mail.tintel.eu [IPv6:::1]) (amavis, port 10032) with ESMTP
 id Lg15FsYpJybe for <linux-bcachefs@vger.kernel.org>;
 Tue,  2 Dec 2025 05:07:31 +0100 (CET)
Received: from localhost (localhost [IPv6:::1])
	by mail.tintel.eu (Postfix) with ESMTP id AC8AE49A0973
	for <linux-bcachefs@vger.kernel.org>; Tue,  2 Dec 2025 05:07:31 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.tintel.eu AC8AE49A0973
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux-ipv6.be;
	s=502B7754-045F-11E5-BBC5-64595FD46BE8; t=1764648451;
	bh=Ip9c8CK2pdGTAEMGv7jz5ZB+0Uil+y3Z32BLrfnTbDE=;
	h=From:To:Date:Message-ID:MIME-Version;
	b=o53zBeiXdHkRbK2xR8N7Os7YpYGirZclvvkONHTQqzRRP+CAstsN1HgHpmWdcKJ/U
	 aXlzDQQxNS6l3bQ/qIjXBEJqgMhxMddvuKeI90efhvaGDXw2Ete73tX2L4vw9c2BaP
	 sLgQpHbW7TDm3/SlOuW04MJeVCzIXr1c31nkNAn8=
X-Virus-Scanned: amavis at mail.tintel.eu
Received: from mail.tintel.eu ([IPv6:::1])
 by localhost (mail.tintel.eu [IPv6:::1]) (amavis, port 10026) with ESMTP
 id 8KsyQLNtc3BF for <linux-bcachefs@vger.kernel.org>;
 Tue,  2 Dec 2025 05:07:31 +0100 (CET)
Received: from taz.sof.bg.adlevio.net (unknown [IPv6:2001:67c:21bc:20::10])
	by mail.tintel.eu (Postfix) with ESMTPS id 62BBF434DE6B
	for <linux-bcachefs@vger.kernel.org>; Tue,  2 Dec 2025 05:07:31 +0100 (CET)
From: stijn@linux-ipv6.be
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH] bcachefs: fix version_upgrade hint
Date: Tue,  2 Dec 2025 06:07:30 +0200
Message-ID: <20251202040730.1478285-1-stijn@linux-ipv6.be>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Rspamd-Pre-Result: action=no action;
	module=multimap;
	Matched map: IP_WHITELIST
X-Rspamd-Server: skulls
X-Rspamd-Queue-Id: 62BBF434DE6B
X-Spamd-Result: default: False [3.59 / 15.00];
	RDNS_NONE(2.00)[];
	R_SPF_FAIL(1.00)[-all:c];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_SOFTFAIL(0.10)[linux-ipv6.be : No valid SPF, No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	ONCE_RECEIVED(0.10)[];
	MX_GOOD(-0.01)[];
	FROM_NO_DN(0.00)[];
	ARC_NA(0.00)[];
	DIRECT_TO_MX(0.00)[git-send-email 2.49.1];
	R_DKIM_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	IP_WHITELIST(0.00)[2001:67c:21bc:20::10];
	FROM_EQ_ENVFROM(0.00)[]
X-Rspamd-Action: no action
X-Rspamd-Pre-Result: action=no action;
	module=multimap;
	Matched map: IP_WHITELIST
Content-Transfer-Encoding: quoted-printable

When an incompatible version upgrade is requested, dmesg suggest
version_upgrade=3Dincompat. Using this mount option throws the following
error:

bch2_parse_mount_opts() Error parsing option version_upgrade: option_valu=
e

The correct value is incompatible; correct the hint to reflect this.

Fixes: c3b02e6d67ac ("bcachefs: Log message when incompat version request=
ed but not enabled")
Signed-off-by: Stijn Tintel <stijn@linux-ipv6.be>
---
 fs/bcachefs/sb/io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/sb/io.c b/fs/bcachefs/sb/io.c
index a81d27b70442..41dc23f3c15f 100644
--- a/fs/bcachefs/sb/io.c
+++ b/fs/bcachefs/sb/io.c
@@ -98,7 +98,7 @@ int bch2_set_version_incompat(struct bch_fs *c, enum bc=
achefs_metadata_version v
 			bch2_version_to_text(&buf, version);
 			prt_str(&buf, " currently not enabled, allowed up to ");
 			bch2_version_to_text(&buf, c->sb.version_incompat_allowed);
-			prt_printf(&buf, "\n  set version_upgrade=3Dincompat to enable");
+			prt_printf(&buf, "\n  set version_upgrade=3Dincompatible to enable");
=20
 			bch_notice(c, "%s", buf.buf);
 		}
--=20
2.49.1

