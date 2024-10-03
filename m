Received: from mail2.ecloud.global (mail2.ecloud.global [135.181.6.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C73147C96
	for <linux-bcachefs@vger.kernel.org>; Thu,  3 Oct 2024 09:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=135.181.6.248
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727947985; cv=pass; b=YUdnWoVj4jHIL7GPlUzQXE7QRos4zFJWPDPekQipPQBtXkGLvVg9z4AmMPMk5BUvKptLfXDL2evpL6GpuZKkYoSy8GXMFRKDD7pS3Z+r+B5Mhr2iUUo5vIzT4GYiGt1v9uD0Ueg6zsasd0f7aiiaJEwlOnV18Rf7zvhd5ThW//s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727947985; c=relaxed/simple;
	bh=QgD+sOr2EGE01DptbZEjvNNtI9yYxcoedcVCDETg0iU=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=VRmlwZQUaW62rZ/iRfU9RuDMbLpyNP68b5muVXH67zPt096tiYJ3AkdaXKZz6At1ksMJXwriFdBx1eIkviqJZ+0eCT2wl2DiknbI5aZLfKFpDB2uw1E8aciSp0IXVvHeZgTnGnYygL5gxox6DZ1OdKbg/oIA/hygZjRNbk+tOJs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=murena.io; spf=pass smtp.mailfrom=murena.io; dkim=pass (1024-bit key) header.d=murena.io header.i=@murena.io header.b=MSaLHFrb; arc=pass smtp.client-ip=135.181.6.248
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=murena.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=murena.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=murena.io header.i=@murena.io header.b="MSaLHFrb"
Received: from authenticated-user (mail2.ecloud.global [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail2.ecloud.global (Postfix) with ESMTPSA id A13C77201A9;
	Thu,  3 Oct 2024 09:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=murena.io; s=mail2;
	t=1727947110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QgD+sOr2EGE01DptbZEjvNNtI9yYxcoedcVCDETg0iU=;
	b=MSaLHFrbpvB/k9YkgbpIBb+JEiFyxlcMUW+NQKxWXAbzXVzpVyslSsba24F0wf3T/fuPGe
	h7fbCM9azvIz9lzr0qjVTPOymkuPzGgC+BlCNRvTzMsriGr8CCQ0Mi8qlx4OJL8oHpRCES
	f0quh26rXRDUQ7vJAZvMTgI2KWa+xhI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=murena.io;
	s=mail2; t=1727947110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QgD+sOr2EGE01DptbZEjvNNtI9yYxcoedcVCDETg0iU=;
	b=Jo38R2o5CDuAqLMhWnK/cxUzqja5ED35V9VARBXZ1EfBeyYdmFBPhG6Lmv1wsLrbEEMGa6
	1ZNSkNFixMrmAyIe2mnld2bFiEPKItIA2d+0GTfhgkaQu1ol6YV93HCXDWSXq6FFUASBGJ
	NPvXyyoo4/PsMiwQFlE/gxgNlOXfbUs=
ARC-Authentication-Results: i=1;
	mail2.ecloud.global;
	auth=pass smtp.mailfrom=integral@murena.io
ARC-Seal: i=1; s=mail2; d=murena.io; t=1727947110; a=rsa-sha256; cv=none;
	b=OifKOiG6uv0fVia3XcucTeb3sTb26uwtafcYalosLpLEm009YaT/+F1HpmZYQy0O8rZHVs
	0sG9ZBp9MICR5Bz5uQoIDUDHF/iMwF1mRsDhkej4H5Litv50UHoxG1Te/0vxbMBCIguSRw
	4SoPlXr9ANCW8rIggLeBn23tU2V2hyc=
Message-ID: <d22be502-5b7a-4da7-80c3-340fcbb5b121@murena.io>
Date: Thu, 3 Oct 2024 17:18:24 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
To: lihongbo22@huawei.com
Cc: integral@murena.io, kent.overstreet@gmail.com, kent.overstreet@linux.dev,
 linux-bcachefs@vger.kernel.org
References: <55b29fbb-3aa8-4ba7-9668-aa19dbb02e78@huawei.com>
Subject: Re: [PATCH] Add support for true/false, yes/no & on/off in bool-type
 options
Content-Language: en-US
From: Integral <integral@murena.io>
Autocrypt: addr=integral@murena.io; keydata=
 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
In-Reply-To: <55b29fbb-3aa8-4ba7-9668-aa19dbb02e78@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Therefore, if my original patch is okay, could you merge it?


Thanks,

Integral

