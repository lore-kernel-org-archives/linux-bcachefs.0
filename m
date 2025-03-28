Received: from wiki.archlinuxcn.org (wiki.archlinuxcn.org [104.245.9.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98826224F6
	for <linux-bcachefs@vger.kernel.org>; Fri, 28 Mar 2025 02:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.245.9.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743129811; cv=none; b=bkKNv3nj5q1Hmb2jT4Rw+k1DGrr0lfUDvNMIVhiF9cL3QOSqvJ2Od2iLpMA/ewSpbnxYqlnPwCQNKStqwM+tSqUKSCOZO36lN674egyCHvlfYr712lua2ZZdxDxARL8c+i1Th+HX16ZuMuJQl0TEdoj6ogr6aj9HMGdP6hzJrJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743129811; c=relaxed/simple;
	bh=SueJtPtAhP3M00C4XStjhl9n9Wiplmc0vKEN4lik9EM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Fo3hZEwhTCAKtLdNMa6nHfUYSR83PORX3DKSCK3Ae/3Uy7EtrgLxjTtVW2TcCu3w9+Rx9ey2fGtkUCbXgE+1Ca5oyAJhcOA95tKKXIGcvxhC2s8B0pdh0WHfRcvYzA7UfEKXcTBnxqBOWlcmgMksy/3/8xTEMmd/1hOirshvKaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org; spf=pass smtp.mailfrom=archlinuxcn.org; dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b=eSloKDfR; arc=none smtp.client-ip=104.245.9.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b="eSloKDfR"
DKIM-Signature: a=rsa-sha256; bh=5TDVdgsuIrz9omjNX8S6RxrJc6EUFHvD6Rj91Jb0DE0=;
 c=relaxed/relaxed; d=archlinuxcn.org;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:Message-Id:Message-Id:References:Autocrypt:Openpgp;
 i=@archlinuxcn.org; s=default; t=1743129775; v=1; x=1743561775;
 b=eSloKDfRtfkB6fKsiFgvLwPTpLgl6fEYxL6PeCXJcLHgtWcmtFSuzZvDZEAChJiXXtYhZwzE
 4xHGDv4P8CfbHE0rFp79H8WI2f233DfDQx0AmTOlWlKYFgsDAYh5WNHcNKenZtRUjv3XmfaglBY
 6ayqPuM+JsTx6hVrZy+08PJ/0mtnT/mIbb5DC+NnjAc1I1x/sp6EGyXj7z4CwFtOIbsFuiLEAIf
 /inAXZHCSXWid9Q+x/L3xcr5t6b/U8QJUBkpeOMvoay62wq1giIx5kE6m/adQMRy3iA1NYz6nge
 5cgUKHB2s8iBSVSoSxhMNNTqeU1omw3rA9oXktR9m77RQ==
Received: by wiki.archlinuxcn.org (envelope-sender
 <integral@archlinuxcn.org>) with ESMTPS id 6105fa31; Fri, 28 Mar 2025
 10:42:55 +0800
From: Integral <integral@archlinuxcn.org>
To: kent.overstreet@gmail.com,
	kent.overstreet@linux.dev,
	lihongbo22@huawei.com
Cc: mmpgouride@gmail.com,
	linux-bcachefs@vger.kernel.org,
	integral@archlinuxcn.org
Subject: [PATCH resend] bcachefs-tools: hide FUSE in usage when BCACHEFS_FUSE disabled
Date: Fri, 28 Mar 2025 10:42:22 +0800
Message-ID: <20250328024221.225699-2-integral@archlinuxcn.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When BCACHEFS_FUSE is disabled or not defined, FUSE section shouldn't
be displayed in bcachefs usage (--help).

Signed-off-by: Integral <integral@archlinuxcn.org>
---
 c_src/bcachefs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/c_src/bcachefs.c b/c_src/bcachefs.c
index aed9c261..f2a1449e 100644
--- a/c_src/bcachefs.c
+++ b/c_src/bcachefs.c
@@ -93,9 +93,11 @@ void bcachefs_usage(void)
 	     "  list                     List filesystem metadata in textual form\n"
 	     "  list_journal             List contents of journal\n"
 	     "\n"
+#ifdef BCACHEFS_FUSE
 	     "FUSE:\n"
 	     "  fusemount                Mount a filesystem via FUSE\n"
 	     "\n"
+#endif
 	     "Miscellaneous:\n"
          "  completions              Generate shell completions\n"
 	     "  version                  Display the version of the invoked bcachefs tool\n");
-- 
2.49.0

