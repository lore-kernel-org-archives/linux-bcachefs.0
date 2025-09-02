Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3658E2FCBF3;
	Tue,  2 Sep 2025 11:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756813938; cv=none; b=X2D/T7Ox61isYv8cYXm8dxgmWaJaU0YWYm89+y/VKW0ktZPjDvre1usP7ZIZkcjmY4TPi3vuT4Np8MT/JHazSxrRtgku442vzxg9v6a9S5Dtp+QNeEwrj1/sxI8Lb6n1Krc+9ZL2LhskLGYXFUMh2vskSFYWSxc8h7qBwb4kMm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756813938; c=relaxed/simple;
	bh=drS9bsgLOeZ6KbXxcPvAG6tNathCtzL7K0Bli0gPO0k=;
	h=MIME-Version:Message-ID:From:To:Cc:Subject:Content-Type:Date; b=Tsio4qD/S5ds6hv27oFBw5h77CP++XDd9KTEWQgL40bBphnjTOL/gJ5gUsbZ9iGPBzwuXvaf5qx1nPBEjhOgz8EeWiBpA2rzttNjMHzyWnrku9Onfi96jZAROsx3XzaVrn2xvL8GHJ3LLIGIZLCo8l2/k+3piKvyr20SVhTLaDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net; spf=pass smtp.mailfrom=gmx.net; dkim=pass (2048-bit key) header.d=gmx.net header.i=shadow_7@gmx.net header.b=sb7075pd; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.net header.i=shadow_7@gmx.net header.b="sb7075pd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.net;
	s=s31663417; t=1756813934; x=1757418734; i=shadow_7@gmx.net;
	bh=drS9bsgLOeZ6KbXxcPvAG6tNathCtzL7K0Bli0gPO0k=;
	h=X-UI-Sender-Class:MIME-Version:Message-ID:From:To:Cc:Subject:
	 Content-Type:Date:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=sb7075pdaASyoEEYxqB2STjq96z1UlH1eQ0dpfXtrSox8sljKZVDJCaOHJlhU0fP
	 vNBWcW0p5PhdI8bFcQ2tUcAxC9OycQRA9/CrJs7a3ii6rmCC04nQiRpmxKTpKUTSK
	 qiT0NigV3b0tfIHWdtOIKX4Hyw20Ur2l3BoDp9zXuF6JPGuMFPCHbLTqbt+O/49+R
	 nTpk81/yn8RcxuxIN0RryydflAb7/Qf6EDONWvqkDRGggiTrTfwrjaKDuqcWozf2i
	 XcboyExX92lY4S18L1pRZdyqqQfkNMC6QKDw5+x/y6fNI2O3s1a4tMExKrgB3d5O1
	 V1DFdGxCkNCH70T/Pw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [194.94.225.248] ([194.94.225.248]) by
 trinity-msg-rest-gmx-gmx-live-c9984495c-7jw5v (via HTTP); Tue, 2 Sep 2025
 11:52:14 +0000
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <trinity-5aa779a3-3784-48ac-86ea-fed7c1c12055-1756813934083@trinity-msg-rest-gmx-gmx-live-c9984495c-7jw5v>
From: Stefan K <Shadow_7@gmx.net>
To: torvalds@linux-foundation.org
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: what does it mean "externally maintained" ?
Content-Type: text/plain; charset=UTF-8
Date: Tue, 2 Sep 2025 11:52:14 +0000
X-UI-CLIENT-META-MAIL-DROP: W10=
X-Provags-ID: V03:K1:3jxqZ4Cbr86ugsRjVOweVDJKiLqj/Jp/dwoB/nsEZKSKqWq0fnvklkeC+3arHe2FLut3G
 WOdymZZBINPrUrk6scv9M1INpbvNCqjo/AV1GgCupwgRWkrgfh8BEjaucASkEP0eZk0vJawBxtxm
 cyA1FNrGQK0MCW1p5W7H2ejFYPJ7cRywd8L4CMa8jqMHv71v9LJDcNSEt3N0GOsSuDrc0jFoMQ6G
 razZfw4pGmLnrAUuZe6zeKgYISga3vvA54jBhOxU0FeDZaQTfIop8jtt+6vPO9Wd9V1aF0Llqasq
 28HrqD/LhftbvszrNMyP58k7n9fp02IKlxKcOjPIskcVhA/wTZPPMR5F9LtnHfzYrE=
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:kHrCIvsQykI=;7MCmqmiF8fByFiTlm6ACUK/abuD
 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
Content-Transfer-Encoding: quoted-printable

Hello Linus,

sorry to disturb you.
I'm just a simple sysadmin.
I saw in the news that you marked bcachefs as "externally maintained". But=
 I don't find what does it mean.

Does it mean..
- it's still there but for new features u need dkms?
- your need to compile/patch it on your own?
- every odd/even kernel version you just copy/merge fs/bcachefs into the k=
ernel-tree?
- at the moment I dont know - see what the future says

Thanks for clarification.
best regards
Stefan=20
