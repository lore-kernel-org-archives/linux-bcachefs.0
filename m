Received: from wiki.archlinuxcn.org (wiki.archlinuxcn.org [104.245.9.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D366C1C68F
	for <linux-bcachefs@vger.kernel.org>; Sat,  5 Apr 2025 12:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.245.9.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743856164; cv=none; b=tcMsRWJmxT/J0Ew95Dmz6lPGgMrs4lXG+5NIYRbP6fNLS5Okx1v8QCxmqnCQYw9qyXSXEGZqb/fhKQI9v+T2+yXhicjRw6RYP+g9cbBgJ6u8ZqaqGdyR5eY9wfk/+N1z6cxdmvzwmJMTrisBG0p4IYFvBLRVmgFwjMiFoWSHxPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743856164; c=relaxed/simple;
	bh=zKdaAPzSnMQVrkkoJwF4MaTpx4ko0W/t3SThgy/kpI8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QR3jPLgF+H5AIFoLeRZBsFUEsv7bwakVky0aOzbrYHJ/pETqVqooRQoqUGv8oVN/pIvL5bIHAvuqiU8/e6mRlhOeX1RjupfP5GTBE+z8Od27CHP85wty6Kf45uFCBOsK73e4SPTW7ZNlii+BBMrIFQEL7AI5ls4TjV6Zz4Grnro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org; spf=pass smtp.mailfrom=archlinuxcn.org; dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b=OixOYElh; arc=none smtp.client-ip=104.245.9.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b="OixOYElh"
DKIM-Signature: a=rsa-sha256; bh=IwMB5gpZsk7JLZVtmM9e4YzHVLWQ5MMqAYtHdAZuubg=;
 c=relaxed/relaxed; d=archlinuxcn.org;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:Message-Id:Message-Id:References:Autocrypt:Openpgp;
 i=@archlinuxcn.org; s=default; t=1743856128; v=1; x=1744288128;
 b=OixOYElhEXGmfivnMkinmuV6CSKJnFtjprySNk4T9XPGrnQIm34Oe1JDfseW/k3s+lxBslqX
 iU+tijMh3P7V9NhD4+XvhNJcepnfU5DlfGZBDPBjUmNcRfV0CWfKkt/6gy8yQzTvK4I/2wIVmXz
 5SUPupM32AVH7b4YQ9A+mGcJVfMCpH8WIYeYnJNqhfys+Y4KMEovZYB32uxvL/hJOQjVmokE+vc
 lT2HPv1OWHdSeQA2kpUndvO3SECFaO9HbM7vFuHAa+LH8Hp6w0xG5O2/bSTwH/MCd3n0HZol7Du
 AKf2iA4r36c4m9Fzie98iaROl3Kh/BQ7MOw/b9exWgmoA==
Received: by wiki.archlinuxcn.org (envelope-sender
 <integral@archlinuxcn.org>) with ESMTPS id 454fcbbf; Sat, 05 Apr 2025
 20:28:48 +0800
From: Integral <integral@archlinuxcn.org>
To: Kent Overstreet <kent.overstreet@gmail.com>,
	Kent Overstreet <kent.overstreet@linux.dev>
Cc: Hongbo Li <lihongbo22@huawei.com>,
	linux-bcachefs@vger.kernel.org,
	Integral <integral@archlinuxcn.org>
Subject: [PATCH] bcachefs-tools: add missing "fs top" command to manual
Date: Sat,  5 Apr 2025 20:25:39 +0800
Message-ID: <20250405122538.11169-2-integral@archlinuxcn.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Integral <integral@archlinuxcn.org>
---
 bcachefs.8 | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/bcachefs.8 b/bcachefs.8
index 30cdd392..37cf0a8f 100644
--- a/bcachefs.8
+++ b/bcachefs.8
@@ -37,6 +37,8 @@ Check an existing filesystem for errors.
 .Bl -tag -width 18n -compact
 .It Ic fs usage
 Show disk usage
+.It Ic fs top
+Show runtime performance information
 .El
 .Ss Commands for managing devices within a running filesystem
 .Bl -tag -width 22n -compact
-- 
2.49.0

