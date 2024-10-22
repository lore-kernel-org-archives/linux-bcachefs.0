Received: from mail2.ecloud.global (mail2.ecloud.global [135.181.6.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6438319E833
	for <linux-bcachefs@vger.kernel.org>; Tue, 22 Oct 2024 18:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=135.181.6.248
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729620168; cv=pass; b=jA1mnkTrg7mTKVDkKRGdXbkFW3jZb3x0ty8s/GN4iDx00/GhMn2y9iipAtwdW0S4o/IUKBbSSUfO8ZMLnwnsV6KKsfh73clTcui8O0v8q8UGr+h1Tv3D9rX47vf3sFP/0PfSIPwvT+ltDh5jM6pQL5ptFbM/DHHgtyr5fcClNSw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729620168; c=relaxed/simple;
	bh=45d+aplBGCnkcluUN+HKUYKBAEaZvT1uZMdFHXRBdv4=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=C7jKf3zU+VrNGXe13hXLfy1nf6HlaAjx5+OeXQ6vdX68N1jxqTXCQUvzEMgU0KfOajVUT5CC5CGmmK+ZV24xNMQdt5sOG6shH5j/hBto1s4Lzng028VbZ5xxOH6t58jU2+07o1iDi2voDD3Mt/xC3c4mvClFqUhZUxXog5uQA88=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=murena.io; spf=pass smtp.mailfrom=murena.io; dkim=pass (1024-bit key) header.d=murena.io header.i=@murena.io header.b=cJVZ9GsU; arc=pass smtp.client-ip=135.181.6.248
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=murena.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=murena.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=murena.io header.i=@murena.io header.b="cJVZ9GsU"
Received: from authenticated-user (mail2.ecloud.global [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail2.ecloud.global (Postfix) with ESMTPSA id BEA2E720090;
	Tue, 22 Oct 2024 18:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=murena.io; s=mail2;
	t=1729620164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=45d+aplBGCnkcluUN+HKUYKBAEaZvT1uZMdFHXRBdv4=;
	b=cJVZ9GsUIPRb3D56EVWB/rQyPhsOnKytXflWNnz/wcn5aPFnp1xCIB+SMH3jdTvmhiuPWf
	pNYJHGHOc0QEgO6rTX0OXSeYiqLYgq9AyxY5ql+WLNVuuyulWkOJIEPe7ZRixaFTEMbOHO
	ix2/2ZRHNOIllOs/fyTXox1GibSQl9I=
ARC-Seal: i=1; s=mail2; d=murena.io; t=1729620164; a=rsa-sha256; cv=none;
	b=Rqdq/LPfqxFvYIYD4bzPRd1WkF8ihO4Uunvm/bYAkbVC/gd5ZFGM5XpMFN/ss4hxxj3QJA
	1PGhgm8fYSG07Av2Zx5RG7jakIcBn0GlowbkFg3xOMzYu+tOXj6XSTWHiklX2dlc7xoCkY
	MoHOsuA8w6qrYosf8lLCvwHL8S2crkc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=murena.io;
	s=mail2; t=1729620164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=45d+aplBGCnkcluUN+HKUYKBAEaZvT1uZMdFHXRBdv4=;
	b=XlXkXbc5iiV3hysH0CKtQmmEJJoH1AKEWVc9607hqjvoor3tY4We90Sa5KZ4L1xVHdLj9O
	iCk/8HieDq7owKC6j1buD/Hf4kkX9plAeuOln0Z7dF+AjiC3yElMQL0v60O0SCfaVVyA+j
	joUbLo+0r/NSL8Y6k8dSA5FLw/0FAbc=
ARC-Authentication-Results: i=1;
	mail2.ecloud.global;
	auth=pass smtp.mailfrom=integral@murena.io
Message-ID: <80532d31-cce2-4146-9247-a78f7d5ef025@murena.io>
Date: Wed, 23 Oct 2024 02:02:38 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
To: integral@murena.io
Cc: kent.overstreet@gmail.com, kent.overstreet@linux.dev,
 lihongbo22@huawei.com, linux-bcachefs@vger.kernel.org, mmpgouride@gmail.com
References: <20241022131218.300195-3-integral@murena.io>
Subject: Re: [PATCH v3] bcachefs: add support for true/false & yes/no in
 bool-type options
Content-Language: en-US
From: Integral <integral@murena.io>
In-Reply-To: <20241022131218.300195-3-integral@murena.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Is my new patch acceptable?

