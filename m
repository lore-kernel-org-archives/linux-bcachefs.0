Received: from mail2.ecloud.global (mail2.ecloud.global [135.181.6.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433F9161
	for <linux-bcachefs@vger.kernel.org>; Sun, 27 Oct 2024 11:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=135.181.6.248
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730027923; cv=pass; b=gbb+/xDqqEm8vk4BorfRVcxRqyJZUoJd3zY0rHKOubSrTJJlGd3n/GbELPfl3WziD3odwkyPeDQbjbHjl/Vg+3UZx0Of8fMVde0BGD+Y10Ek9KcZasUZrki2Ada+S8+/KDrTNoW39akkWqIXn2drnuOBRu7x2TwHePSMaf71qJw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730027923; c=relaxed/simple;
	bh=7i5N4H1gTFfq3tjgOzEVl5KM71i3COTaCU+usnSUN/A=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=ag1uUxWnjjPvpbgOnt7piCJI5a31/gA3PCXj8C9MdYbMYPNO8kul98jG55nIec261V7GpOiP4kvtpZ2OgE/Dgk180OQQ6nX53hEQXGH2/AyKp5+C1qf7ly6X8UxnRp28q8cSMgVC3BvpjzaXKVKMIRuDHJ7jgATqsCZVPIU3/84=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=murena.io; spf=pass smtp.mailfrom=murena.io; dkim=pass (1024-bit key) header.d=murena.io header.i=@murena.io header.b=LyHI1l5b; arc=pass smtp.client-ip=135.181.6.248
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=murena.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=murena.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=murena.io header.i=@murena.io header.b="LyHI1l5b"
Received: from authenticated-user (mail2.ecloud.global [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail2.ecloud.global (Postfix) with ESMTPSA id 2E71B720600;
	Sun, 27 Oct 2024 11:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=murena.io; s=mail2;
	t=1730027912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7i5N4H1gTFfq3tjgOzEVl5KM71i3COTaCU+usnSUN/A=;
	b=LyHI1l5b/WE7/DYINRcb31Id1MkE32dNqttEiWn2XrVGsapdjUTMNWGwKAPgwlQzc2Cur3
	YHF473lQWDj4Sj+KK4PN2s3u6lm6HEaYTWNKZ4pqMzRUFiKNeNMWidd/jodeJFMKhuCoGH
	BS6I9pe65NcetOetqiYMen5WBTgBLus=
ARC-Seal: i=1; s=mail2; d=murena.io; t=1730027912; a=rsa-sha256; cv=none;
	b=Am6h7bnl2JOIUd+yA9kFrPDD3Sr4Q7bcNG1QBfnX8qBps3q0Ez3rlCa4kbNqjlsjx6+068
	p3aClTDnEzdqrF1YTavEvjml3KtA7iFZExNqQVBtyyAMSO3sMdTte2Jy9/VOUpnnrxDz+I
	wQ3mIRa//3o7xelqCPltmxxugsRAFG4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=murena.io;
	s=mail2; t=1730027912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7i5N4H1gTFfq3tjgOzEVl5KM71i3COTaCU+usnSUN/A=;
	b=jwu3mMSGKksBGgc8tEie8at2trTEGQNn0dWWevlhEdaQDU30H4COJVoPBQAp4nOrFzWQT5
	3jgUs1F854Jcfbj+atz71v7kzrinNRrzCsiY+hf/zWCmgRy7WnwQrk9MyuPUIzjAURRjEi
	GfSnc3Wy5bcU0tt93dMbvc2qMC9V0j0=
ARC-Authentication-Results: i=1;
	mail2.ecloud.global;
	auth=pass smtp.mailfrom=integral@murena.io
Message-ID: <1b530df3-0f67-4bfa-8438-3f79eda5e7ba@murena.io>
Date: Sun, 27 Oct 2024 19:18:25 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
To: mmpgouride@gmail.com
Cc: integral@murena.io, kent.overstreet@gmail.com, kent.overstreet@linux.dev,
 lihongbo22@huawei.com, linux-bcachefs@vger.kernel.org
References: <3384DDD6-51C6-46BD-8FB1-4569FAEEC6A7@gmail.com>
Subject: Re: [PATCH v5] bcachefs: add support for true/false & yes/no in
 bool-type options
Content-Language: en-US
From: Integral <integral@murena.io>
In-Reply-To: <3384DDD6-51C6-46BD-8FB1-4569FAEEC6A7@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

If my latest patch is acceptable, could you please apply my patch? :)
