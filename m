Received: from mail.af.tnxip.de (mail.af.tnxip.de [212.53.203.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79181FF04A
	for <linux-bcachefs@vger.kernel.org>; Fri, 25 Oct 2024 18:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.53.203.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729882374; cv=none; b=ZDLDKHb+hNyQPiSSXIwhX2KwMXz6Sjon/gO/4Lv6Cpz9Wyqzc/8cfX3Lp2QmHl+6IpxiXfOSoPKjZV4BFxsKAxXDpUzhsB036Mrupwae7LNL4XnRpOGR3CdZWaFfOfn+DAGxj2Zdhrfxor6v/7TR92qPeBESnxw9Uwa5s+sZ4g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729882374; c=relaxed/simple;
	bh=KdqGD7yHJnLnHZkEQ/I5qFv+qK481LWWnGuKCNChcYo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gikgRfkpUzRa7YrjOUMLBr4qHKmJXnaZq430IRkSbIgafYWEi7aPcIAg31FT022JWOhqP8geQxq63hvxcjF2wD9j8BuUkBvFzlS9ptfecH5KjOmhQ7DwuU3PzjFj51Kqwf0ym7j68xC8G7rd+SNOO+k/9HLR6ujxkmVzKgej5V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tnxip.de; spf=pass smtp.mailfrom=tnxip.de; dkim=pass (1024-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=doaYxczI; dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=VxwhtBGu; arc=none smtp.client-ip=212.53.203.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tnxip.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tnxip.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="doaYxczI";
	dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="VxwhtBGu"
Received: from gw.tnxip.de (unknown [IPv6:fdc7:1cc3:ec03:1:7f30:b2f6:f140:628f])
	by mail.af.tnxip.de (Postfix) with ESMTPS id D64C7201D1
	for <linux-bcachefs@vger.kernel.org>; Fri, 25 Oct 2024 20:52:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tnxip.de; s=mail-vps;
	t=1729882356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XoroAe2CoXl7NEdxF6Vvceu7ULa7RzWHRYmAdITxUSc=;
	b=doaYxczILs+8GR/u7ncIrGHA3GtotKQoAR16KFIOIK+YeGFFdyhXWSo30xeW9xXgONnmql
	4ALI7e9kVY7KxyOzEU8+1HaChT5+I1380Cw2pkOTkgocVl2fuwGhNH/JVf+ghEJngNeU4B
	cSjnJMLEcKV/nNno8kZPgOO5XlHVbbA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=tnxip.de;
	s=mail-vps-ed; t=1729882356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XoroAe2CoXl7NEdxF6Vvceu7ULa7RzWHRYmAdITxUSc=;
	b=VxwhtBGudWTOtbtfeoWqf7INbb/VnW3MI63pBeHFXNo31RpRzyXHCmurUgAX7HoW5KROO5
	rVYiEyiae3hTc0CA==
Received: from highlander.lan.tnxip.de (highlander.local [IPv6:fdc7:1cc3:ec03:1:2696:2123:8a1e:e0a1])
	by gw.tnxip.de (Postfix) with ESMTP id 4F6DD6003D3EE;
	Fri, 25 Oct 2024 20:52:31 +0200 (CEST)
Authentication-Results: gw.tnxip.de;
	dkim=none;
	spf=temperror (gw.tnxip.de: error in processing during lookup of malte.schroeder@tnxip.de: DNS error) smtp.mailfrom=malte.schroeder@tnxip.de;
	dmarc=temperror reason="SPF/DKIM temp error" header.from=tnxip.de (policy=temperror)
From: =?UTF-8?q?Malte=20Schr=C3=B6der?= <malte.schroeder@tnxip.de>
To: linux-bcachefs@vger.kernel.org
Cc: =?UTF-8?q?Malte=20Schr=C3=B6der?= <malte.schroeder@tnxip.de>
Subject: [PATCH] Allow multiple targets for subvolume delete.
Date: Fri, 25 Oct 2024 20:52:26 +0200
Message-ID: <20241025185226.122701-1-malte.schroeder@tnxip.de>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: /
X-Spamd-Result: default: False [0.90 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	MIME_GOOD(-0.10)[text/plain];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_ZERO(0.00)[0];
	RBL_SEM_IPV6_FAIL(0.00)[fdc7:1cc3:ec03:1:2696:2123:8a1e:e0a1:query timed out];
	R_SPF_DNSFAIL(0.00)[-any];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	R_DKIM_NA(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DMARC_DNSFAIL(0.00)[tnxip.de : SPF/DKIM temp error,reject];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RBL_VIRUSFREE_UNKNOWN_FAIL(0.00)[fdc7:1cc3:ec03:1:2696:2123:8a1e:e0a1:query timed out];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[highlander.lan.tnxip.de:helo]
X-Rspamd-Server: starbase1
X-Rspamd-Queue-Id: 4F6DD6003D3EE

Signed-off-by: Malte Schröder <malte.schroeder@tnxip.de>
---
 src/commands/subvolume.rs | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/src/commands/subvolume.rs b/src/commands/subvolume.rs
index bb0141c4..7df20819 100644
--- a/src/commands/subvolume.rs
+++ b/src/commands/subvolume.rs
@@ -24,7 +24,7 @@ enum Subcommands {
     #[command(visible_aliases = ["del"])]
     Delete {
         /// Path
-        target: PathBuf,
+        targets: Vec<PathBuf>,
     },
 
     #[command(allow_missing_positional = true, visible_aliases = ["snap"])]
@@ -58,15 +58,17 @@ pub fn subvolume(argv: Vec<String>) -> Result<()> {
                 }
             }
         }
-        Subcommands::Delete { target } => {
-            let target = target
-                .canonicalize()
-                .context("subvolume path does not exist or can not be canonicalized")?;
+        Subcommands::Delete { targets } => {
+            for target in targets {
+                let target = target
+                    .canonicalize()
+                    .context("subvolume path does not exist or can not be canonicalized")?;
 
-            if let Some(dirname) = target.parent() {
-                let fs = unsafe { BcachefsHandle::open(dirname) };
-                fs.delete_subvolume(target)
-                    .context("Failed to delete the subvolume")?;
+                if let Some(dirname) = target.parent() {
+                    let fs = unsafe { BcachefsHandle::open(dirname) };
+                    fs.delete_subvolume(target)
+                        .context("Failed to delete the subvolume")?;
+                }
             }
         }
         Subcommands::Snapshot {
-- 
2.47.0

