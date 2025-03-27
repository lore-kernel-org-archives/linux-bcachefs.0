Received: from wiki.archlinuxcn.org (wiki.archlinuxcn.org [104.245.9.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C2C1E505
	for <linux-bcachefs@vger.kernel.org>; Thu, 27 Mar 2025 06:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.245.9.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743057507; cv=none; b=F7/ETsjtrm7ycdXSFZY1aB24wENUUnFlVL/i/8eznpYz++2aU3UxkYh+zckqq7W0xu48G4QtiY+CThcQLTHYTIatM1QlxaOiX0pgy74Ky4mds5+pvLCArOP97KJBUTYN0Ak1FCQ2M6Z0fMZd8mXylEoNhQHBoeC65xgQ6mBVc3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743057507; c=relaxed/simple;
	bh=45iEoHkGo6ZGTU/yB0Fbf8YEZF6HsXio7J43aDc3ftc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JphHrq5lKgnttcTYR14AXK6NBkyKSmbZ//coVKfyvSQt5wYoLU7xLUATtVy/Qskibpm0CjPintfUAMFqWDVr6bP33aDfd2FBsmD1DsB89nYmXLcSj2ukQRmMS67d4tlvkH+kcw//EyhfhpIuEokO+w9I8V3dGFLvPxxshDD1zZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org; spf=pass smtp.mailfrom=archlinuxcn.org; dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b=MSDvU+pH; arc=none smtp.client-ip=104.245.9.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b="MSDvU+pH"
DKIM-Signature: a=rsa-sha256; bh=3hUWt6c5N7wTqe0+1t8J/SwyoG8EMRPe5JhX4iPVzNg=;
 c=relaxed/relaxed; d=archlinuxcn.org;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:Message-Id:Message-Id:References:Autocrypt:Openpgp;
 i=@archlinuxcn.org; s=default; t=1743057478; v=1; x=1743489478;
 b=MSDvU+pHGjdnFCy9AofjVplEPXPJfJX7jnuOICJW7pHrP18FpY/bMMZd593j8s7e2inEoKUl
 l3O7i/XTl9NOaeGpbtYZcRbYqVIERD8LXlGEi091IMGfEp/qfq3CnEBeHniTilxYzR5au4RGBOw
 fuYZ8UGTIodpXUYjHWBP3JucnR+VhXLfThZhiDi89xOH+TvHAWh4XpK1TcWv0wfXI+PBKiJFozy
 8A2cfvBcBFtDv1DxbHWXFwOdAM2FcU3/bc09v5hq1JIt0GCArWSG1lBIptQpkn5E5xdpPGNDx43
 8fdEOdKYZht5JNmdUTY7D/MjP4PEiQirBQ3lp/7RnHphw==
Received: by wiki.archlinuxcn.org (envelope-sender
 <integral@archlinuxcn.org>) with ESMTPS id a9a87ac2; Thu, 27 Mar 2025
 14:37:58 +0800
From: Integral <integral@archlinuxcn.org>
To: kent.overstreet@gmail.com,
	kent.overstreet@linux.dev,
	lihongbo22@huawei.com
Cc: mmpgouride@gmail.com,
	linux-bcachefs@vger.kernel.org,
	integral@archlinuxcn.org
Subject: [PATCH] [PATCH resend] bcachefs-tools: make targets of subvolume create/delete required
Date: Thu, 27 Mar 2025 14:37:19 +0800
Message-ID: <20250327063718.211541-2-integral@archlinuxcn.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, when no targets are provided for "bcachefs subvolume create" or
"bcachefs subvolume delete", it will exit silently with code 0. Make targets
(arguments) required to solve this problem.

This patch solves issue https://github.com/koverstreet/bcachefs/issues/766.

Signed-off-by: Integral <integral@archlinuxcn.org>
---
 src/commands/subvolume.rs | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/commands/subvolume.rs b/src/commands/subvolume.rs
index 7df20819..6f5f2f2b 100644
--- a/src/commands/subvolume.rs
+++ b/src/commands/subvolume.rs
@@ -18,12 +18,14 @@ enum Subcommands {
     #[command(visible_aliases = ["new"])]
     Create {
         /// Paths
+        #[arg(required = true)]
         targets: Vec<PathBuf>,
     },
 
     #[command(visible_aliases = ["del"])]
     Delete {
         /// Path
+        #[arg(required = true)]
         targets: Vec<PathBuf>,
     },
 
-- 
2.49.0

