Received: from wiki.archlinuxcn.org (wiki.archlinuxcn.org [104.245.9.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D106A32C8B
	for <linux-bcachefs@vger.kernel.org>; Sat,  9 Nov 2024 10:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.245.9.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731148044; cv=none; b=qj6JBXGxzqF2tA+L8uHPSHPbk7xMHH8tdzjcYSDwdyF72vlYv/DacYIiMPrEG3roEiISfTyiBmPmzBC7FHK9ZPuDqAdhYo19UHK6JInX+GAOqSzVAuHjSUeK5ekqVmyi/+p+JgtWX0v49/wx3+lQpLcnBj2IaBx6JgwIzzsF43I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731148044; c=relaxed/simple;
	bh=r8X652zIulk42xnbqZ1VYHVb3nQEqSdMF/MEFipwNXw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=biYK8La2i+M/uDffNtY1vRoK2d7AT+W3LbWy7GjC8ZPNScoD2viQP4abJXBxHPljn3nc8t6iuvYSMWv/8kbCW+VTSNoHW7Seim2dkkd7ndjxYunzMkTfy3GDsPWHb/r0Kk4h3U4esv8Q+2tOpVXcrG/7B6jV1hATY1KDvSIhUuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org; spf=pass smtp.mailfrom=archlinuxcn.org; dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b=YhkQabNn; arc=none smtp.client-ip=104.245.9.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b="YhkQabNn"
DKIM-Signature: a=rsa-sha256; bh=wvrf5C/ERxKvf3NjQagxUaHFTuMAJIQN2wQB8q2yEr8=;
 c=relaxed/relaxed; d=archlinuxcn.org;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:Message-Id:Message-Id:References:Autocrypt:Openpgp;
 i=@archlinuxcn.org; s=default; t=1731148022; v=1; x=1731580022;
 b=YhkQabNnMZy3d8sFaWzB9FPtqvPORqMRSrasj6bK79jS3JP/yX589a+pUjONrBJ6qlwnYrOF
 0utltNlDfO9accmy8Deg8L7G2n+aeG09whlzGrB+h7//fmeRZHvXa40q3M7m7d+NI5skZDilo9B
 LgEFCPoU7Qo2COMZLnEF1w5830OXuTacHUT7tnd4jwyUFhQB8OhS7Ss0UsYlGkZsi4d1++mh7/O
 kSi9uIwYTPsRAe1Ge18CXYWPrQC1nXmqqLTBixf1g5x1fjP/qPaMzPpNYCzwunaXu89NScrsZqk
 CBV/lUHYF+qr5qXn0ObhKI71378aWNLNgwTbtY/kBscSA==
Received: by wiki.archlinuxcn.org (envelope-sender
 <integral@archlinuxcn.org>) with ESMTPS id 3c28e635; Sat, 09 Nov 2024
 18:27:02 +0800
From: Integral <integral@archlinuxcn.org>
To: kent.overstreet@gmail.com,
	kent.overstreet@linux.dev,
	lihongbo22@huawei.com
Cc: mmpgouride@gmail.com,
	linux-bcachefs@vger.kernel.org,
	integral@archlinuxcn.org
Subject: [PATCH] bcachefs-tools: hide FUSE in usage when BCACHEFS_FUSE disabled
Date: Sat,  9 Nov 2024 18:25:37 +0800
Message-ID: <20241109102536.99885-2-integral@archlinuxcn.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When BCACHEFS_FUSE is disabled or not defined, FUSE section shouldn't be displayed
in bcachefs usage (--help).

Signed-off-by: Integral <integral@archlinuxcn.org>
---
 c_src/bcachefs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/c_src/bcachefs.c b/c_src/bcachefs.c
index 77bf6215..9fe4fa1e 100644
--- a/c_src/bcachefs.c
+++ b/c_src/bcachefs.c
@@ -90,9 +90,11 @@ void bcachefs_usage(void)
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
2.47.0

