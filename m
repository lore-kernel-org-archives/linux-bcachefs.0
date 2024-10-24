Received: from mail3.ecloud.global (mail3.ecloud.global [135.181.139.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDC5145B18
	for <linux-bcachefs@vger.kernel.org>; Thu, 24 Oct 2024 07:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=135.181.139.185
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729754235; cv=pass; b=YAbAFZ7EA3hMwUd4nTR3D2Arr7rB7zwyI+XYRvfGkBnyxbrfKUGw+1bPEBnFk7aksUyQnNXWKUJ1YRnXJ5db7mKCzuqC/oPnChtOztdLzlAnAwk/QrN+jYJUDyyUeVFgB3mkaYKFUWd3+RTq/74p/oKYmLnhkxtyQkLgx78s1w4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729754235; c=relaxed/simple;
	bh=HAZcudmVvqZOKtevz5M8knk3JlgEch+E2Okuaj7XfrQ=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=i1WouLUCauC/6eHnyBUOS47S3ZCJCYoJ9KS6qRDlf3Wb3yhpUo67fB5sT23+6MXGbLZyMR2mEtoG2v1ECxKDxOMu8pGDs7DOC525peo4ZdH4+nRcgCb76/TNGAo2jLVHJSUHimGspLfr8D7d/aAC5vof9aL7+PTbaKN6W8cPYYU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=murena.io; spf=pass smtp.mailfrom=murena.io; dkim=pass (1024-bit key) header.d=murena.io header.i=@murena.io header.b=TG3/k9Em; arc=pass smtp.client-ip=135.181.139.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=murena.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=murena.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=murena.io header.i=@murena.io header.b="TG3/k9Em"
Received: from authenticated-user (mail3.ecloud.global [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail3.ecloud.global (Postfix) with ESMTPSA id 1214F881527;
	Thu, 24 Oct 2024 07:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=murena.io; s=mail3;
	t=1729754225;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HAZcudmVvqZOKtevz5M8knk3JlgEch+E2Okuaj7XfrQ=;
	b=TG3/k9EmDlWeipA67FjMyTbAO/FcmKGExUJt5uH1/bIltUdfzLrBmCQFVEi9SZXx2JbaOG
	QHUtf1yfksN8WW7+ZLVP5Jbdab6oKdLN5UiD5VN2INyTqobOF+lM7TTpddkoohFvR2Csv3
	tPQuH6OUqPQ/pT+iMtqBrdplqnSa7DM=
ARC-Seal: i=1; s=mail3; d=murena.io; t=1729754225; a=rsa-sha256; cv=none;
	b=5/5Jj0WcbLnKmu/FKh0OF+z5oIvXZzjgnIf2FHz+v7zpArP+mF0sNR6WW+Ueqth6FP5Rt1
	Bwyfc9dZAU2pErxptkuqe7GLBwhhQk2ddPrVxDjTP3C/KVHad0QVumaToHHn1aMFt6mWTf
	Sw+cIdYnnwwvYeSk4rGdrwtB1kd2mUQ=
ARC-Authentication-Results: i=1;
	mail3.ecloud.global;
	auth=pass smtp.mailfrom=integral@murena.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=murena.io;
	s=mail3; t=1729754225;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HAZcudmVvqZOKtevz5M8knk3JlgEch+E2Okuaj7XfrQ=;
	b=nM/rDbjH2UP33eKfN3TE+YWjuqM6bT9fMjRd8C+WOTms35Xp7AHyg8LkUr/nFtb1S7ITxf
	rJba3nDOJt7RLGmP2nAYFNK958Lfn0fR++F3A1S54gu8HIgAeJq9KKzSWq0jhVwpRzAMYy
	6F9xeRyzK0n6lsN/zpe/mze4J4MkVgM=
Message-ID: <906b76f2-479d-4d12-b9ed-eb19fb108079@murena.io>
Date: Thu, 24 Oct 2024 15:16:59 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
To: integral@murena.io
Cc: kent.overstreet@gmail.com, kent.overstreet@linux.dev,
 lihongbo22@huawei.com, linux-bcachefs@vger.kernel.org, mmpgouride@gmail.com
References: <20241023100033.166289-1-integral@murena.io>
Subject: Re: [PATCH v5] bcachefs: add support for true/false & yes/no in
 bool-type options
Content-Language: en-US
From: Integral <integral@murena.io>
In-Reply-To: <20241023100033.166289-1-integral@murena.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Is my v5 patch more acceptable?
