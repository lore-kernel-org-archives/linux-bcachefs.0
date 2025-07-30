Received: from mail-4323.protonmail.ch (mail-4323.protonmail.ch [185.70.43.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACC1CA4E
	for <linux-bcachefs@vger.kernel.org>; Wed, 30 Jul 2025 05:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753852377; cv=none; b=EzoYqiX/9K/tVj/wMptwDk/v4CNJtVN+pCL1ebgXDlUBB1RBp453X3esr1zmHkKjA8V6mc7bKty1bMf9baMvApr8udpAcgnqzOQzBAe7k1pxD/jurmydW5mA3PrCWVCUr01gbKHrGS6GhrqTFdKKIGd43jxjfNvxLISrtDUiBvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753852377; c=relaxed/simple;
	bh=+XXqz3dCUyQS8GBsTDjrbWJtK7vtchQrl+Ors78vL6M=;
	h=Date:To:From:Subject:Message-ID:MIME-Version:Content-Type; b=sl5NceFVGpX5hez0auna6Df1jAdpjf5YS/NBw6Ln6LZLtjhMLa7Yh+Uk68/8TmCxDf3VWGrewYmSfUGNLVOG7s6X7B70HNXgfDGPJd26bB1/eIord34YnW49UycO/iM7OwmHxlJ9GyTzivfmeDDOmE0g5wXCP0GW1Gb5cMIXado=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=riley.engineer; spf=pass smtp.mailfrom=riley.engineer; dkim=pass (2048-bit key) header.d=riley.engineer header.i=@riley.engineer header.b=jV5e7WhM; arc=none smtp.client-ip=185.70.43.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=riley.engineer
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=riley.engineer
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=riley.engineer header.i=@riley.engineer header.b="jV5e7WhM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=riley.engineer;
	s=protonmail3; t=1753852363; x=1754111563;
	bh=nSXa59HyaYlf44O6a4M6dbya+d0davDDPpqaud4wRp0=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=jV5e7WhMNC/SncmhYo7Iu3+dK1enz5BUdl5EEMeDRHMxvDqwtAN3ZNUn1BhuQJQrz
	 lPc4vjt9FB29ahLP3rQYGBi9Uz9PZB5nCDZrWqVI43t8REK4ZlMjE9RtYdSf4qyscV
	 giRvN2z8NHlfCRPh57750vy/JDTBc9vje17FiwU91yxMu+C/mA1GUOnR0IDX3KVkOA
	 Am5o6fhXIOblkgkF2w506GZg54r8dPCQNGiIYzFCzRm0n0QnVVKxZURoCNkhdY5T9n
	 YX0eldikyWcR+hgsVjSjG34Tx4E0h1Wkrh7JO3UwKERCohJGQ5aGYnWn+zAQidwrEo
	 TFxbaz9UPd47Q==
Date: Wed, 30 Jul 2025 05:12:40 +0000
To: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
From: Reed Riley <reed@riley.engineer>
Subject: [PATCH] bcachefs: expose reflink_p may_update_opts in sysfs
Message-ID: <cE2ToM_C9lRpiqHsQ6LQAim5iKoW2c-RNTjehjV0F0bwhXnSKKqd1ZCr23UyeK1asFR0P3WtBC4kvTV3_pzLIJfYFCyi0W6mcUJ0FXZgO7M=@riley.engineer>
Feedback-ID: 15554401:user:proton
X-Pm-Message-ID: 41539e7e89254e57dbb94660b191f53d2b3e0523
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Surfacing this will potentially allow userspace utilities to reason about w=
hich inodes control the propagation of bcachefs options to reflink_v extent=
s.

---
 fs/bcachefs/reflink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/bcachefs/reflink.c b/fs/bcachefs/reflink.c
index 92b90cfe622b9..84218efa1029e 100644
--- a/fs/bcachefs/reflink.c
+++ b/fs/bcachefs/reflink.c
@@ -65,6 +65,9 @@ void bch2_reflink_p_to_text(struct printbuf *out, struct =
bch_fs *c,
               le32_to_cpu(p.v->front_pad),
               le32_to_cpu(p.v->back_pad));

+       if (REFLINK_P_MAY_UPDATE_OPTIONS(p.v))
+               prt_str(out, " may_update_opts");
+
        if (REFLINK_P_ERROR(p.v))
                prt_str(out, " error");
 }
--
2.50.0
