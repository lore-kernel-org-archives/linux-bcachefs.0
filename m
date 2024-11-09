Received: from wiki.archlinuxcn.org (wiki.archlinuxcn.org [104.245.9.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4861233D7D
	for <linux-bcachefs@vger.kernel.org>; Sat,  9 Nov 2024 10:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.245.9.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731149929; cv=none; b=H/Y/GYntWe8a0945+k5uS4wB36A6kELhoNRgKiA4icU5InkPrtU/3h0IHusMZhY3kSISa9aroTRr33fuAnMfHnwBlnZLakXS6nPxY+oUbHc7mnc0brpw/Rhxwp7qTXEdDpbp0sCOvEpk7llq4qbg2PnEuSbEtpsMxiGw59mjics=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731149929; c=relaxed/simple;
	bh=2JGKbWMJFzt6KbljlUxowmrD+U+zNZ+J9pcyXvhw2Pc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q7IKpgqlwmI1MAWzQn+DTzKY3HvGCsn67ixh91QRRVP8a38KHx2279dbunP0s4DQldZfI41ApRUZoSK8Em9/eUd+wdwk0be9RhvKkepOJ3jdbYGbl7IcpZXy007nOsBMQmLN62e7geKepiFRS6990CEwbYDizPuVG0Kw6KvOW3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org; spf=pass smtp.mailfrom=archlinuxcn.org; dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b=JmD0GGBF; arc=none smtp.client-ip=104.245.9.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b="JmD0GGBF"
DKIM-Signature: a=rsa-sha256; bh=14R7TJklcTc5wE0PifP6cXAL8HWCtvQn3OriUxQfoik=;
 c=relaxed/relaxed; d=archlinuxcn.org;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:Message-Id:Message-Id:References:Autocrypt:Openpgp;
 i=@archlinuxcn.org; s=default; t=1731149904; v=1; x=1731581904;
 b=JmD0GGBFKK60Zt2zYpLim/MAOL2sJ5d0YOJEc+bysb9yrby5mONRV77fseQx9c3IWGwVmuwN
 0k2K1tghaSqb49uJ4BesCgxcAvrbqFWP1uOgWAEm2MOnKqceRAGQovPc3v7Litldd3TvcvuJ3SN
 HJ9je4CBPKy5fbJ5f28n5mt5/MvX4Kh2crAq9tlZBYyyKeBmYAMc+ZUYx3vj/3IQZ0UGj6DMvkD
 QA5JEGpQjVJIWp8uR9CS+4kvpTDJ1VVHKN2jNu6gMf/fhzujaOdjDv6mYJKUymGLgDgEP9ltJkN
 s84wQVNOQFI+SJbyw0XXxfU0x45CqWDdtuYxcOjraZtUw==
Received: by wiki.archlinuxcn.org (envelope-sender
 <integral@archlinuxcn.org>) with ESMTPS id 1902c822; Sat, 09 Nov 2024
 18:58:24 +0800
From: Integral <integral@archlinuxcn.org>
To: kent.overstreet@gmail.com,
	kent.overstreet@linux.dev,
	lihongbo22@huawei.com
Cc: mmpgouride@gmail.com,
	linux-bcachefs@vger.kernel.org,
	integral@archlinuxcn.org
Subject: [PATCH] bcachefs-tools: make targets of subvolume create/delete required
Date: Sat,  9 Nov 2024 18:57:41 +0800
Message-ID: <20241109105740.105652-2-integral@archlinuxcn.org>
X-Mailer: git-send-email 2.47.0
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
2.47.0

