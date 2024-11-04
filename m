Received: from mail3.ecloud.global (mail3.ecloud.global [135.181.139.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FADB1CD02
	for <linux-bcachefs@vger.kernel.org>; Mon,  4 Nov 2024 17:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=135.181.139.185
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730741456; cv=pass; b=Cly4MuX5xfq0O21cN52j+Zu6b2CxRwShIW+sZLiCabl2q3uxBG9dGTy7wYn5S4JlaUJL9GJCirS4pLHdvZ+75PLfQUW/ZUZvt3rHuEt2mxBJdI8/zruvYMdhN4moTx0QrYLRZYrGLLg8IR7/iy+LKMHpzXB9HK18/JozK7XPtoM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730741456; c=relaxed/simple;
	bh=VG9+kXooZb5tKB7BKX7hXjyGq6C4B+u49pxgx3XnqkE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=retTsgKoKgkfduMCl2hJNhI8NVEtgjFUUG6+VoaIDd1+SmGpB/wcd/UeI329pHP6tvnmwMqJPoFl1c3JEXdYEGjWbznWV3voiEBlbMExXfI3cXdeTFSbK0XZsjxwzoJnTyDo1XdpjqZ9Pg7pao1w+TActNdd1kGFAUPtwPvTuPc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=murena.io; spf=pass smtp.mailfrom=murena.io; dkim=pass (1024-bit key) header.d=murena.io header.i=@murena.io header.b=n2SvcUC/; arc=pass smtp.client-ip=135.181.139.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=murena.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=murena.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=murena.io header.i=@murena.io header.b="n2SvcUC/"
Received: from authenticated-user (mail3.ecloud.global [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail3.ecloud.global (Postfix) with ESMTPSA id 99AA0884700;
	Mon,  4 Nov 2024 17:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=murena.io; s=mail3;
	t=1730741447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VG9+kXooZb5tKB7BKX7hXjyGq6C4B+u49pxgx3XnqkE=;
	b=n2SvcUC/ngKxU8dsrfK+mBdeaw4ZkXjHc3eonyXAB+AvaU7jhJgPX5jHTgd89SzyJ5Fg8X
	w32Ji8QLizFTJq/l7JLRAWRC9o0brPNDFu3kc8BakyslK7VwrqPm9ZZGd62zhkQVx11ngm
	J6OdzoSx+YSl190QDEuFqoEgDyKYaqU=
ARC-Seal: i=1; s=mail3; d=murena.io; t=1730741447; a=rsa-sha256; cv=none;
	b=gJpFwZvZzH9vzcShMP26x0zNsrnJvO09H7jqzQrsGaJEeU8TEbKGu16QBiMk2c+JDfOH2S
	IszuILhyv4nCgJARQ5j9SjKWzU4YveH5S33XLBKvvuohQsgLz1npuazDEy4t5N55+jWuBZ
	PkZT5EpjpPevaJ6mfS5ThiCtxNPvYnA=
ARC-Authentication-Results: i=1;
	mail3.ecloud.global;
	auth=pass smtp.mailfrom=integral@murena.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=murena.io;
	s=mail3; t=1730741447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VG9+kXooZb5tKB7BKX7hXjyGq6C4B+u49pxgx3XnqkE=;
	b=Ccxv7GVTZB4YvXno1NNdWACiXF1kMMd77ayDPr0kKdxhFXaS2lpNXmmX2qWXYpWOt9xGo0
	ER1bKMjEBIOX1I5/4+GPwbyAaRikh4aQ244y4sgNddajnfdaDJ0NiLOqNF7OZVgwPjnCtw
	77aX4MVFDSPiB8F6rvEa1XFI1KsIDAU=
Message-ID: <31986846-1261-4e94-a452-0010c542f7b2@murena.io>
Date: Tue, 5 Nov 2024 01:30:41 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v5] bcachefs: add support for true/false & yes/no in
 bool-type options
To: mmpgouride@gmail.com
Cc: kent.overstreet@gmail.com, kent.overstreet@linux.dev,
 lihongbo22@huawei.com, linux-bcachefs@vger.kernel.org, integral@murena.io
References: <3384DDD6-51C6-46BD-8FB1-4569FAEEC6A7@gmail.com>
 <1b530df3-0f67-4bfa-8438-3f79eda5e7ba@murena.io>
Content-Language: en-US
From: Integral <integral@murena.io>
In-Reply-To: <1b530df3-0f67-4bfa-8438-3f79eda5e7ba@murena.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi, Alan Huang

Give you a friendly ping :)


On 10/27/24 7:18 PM, Integral wrote:
> If my latest patch is acceptable, could you please apply my patch? :)
