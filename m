Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727F7127E25
	for <linux-bcachefs@vger.kernel.org>; Tue, 30 Apr 2024 09:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714469427; cv=none; b=uAg6JPtD2LPWVGS99+VLk5TH8qRWJX2qw1Gf+WiOXZlbO7scx8pCrRghSYMcn1hI1H3Z3AMxeRIN2m0WrBVbFp4aeyFRm1hSlWuzsrklUKDMHCn+JqHA7t2mOD01VJat80xs3wtOwSKSeaO8h0mez3b8U0pPsy+1QqVnpXG1qdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714469427; c=relaxed/simple;
	bh=lC3I7ZBJaD+fg9kzuIidBBEutjLohficzyxGQXhxxlA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GLsOk6XsA31Zniqp8Uv/wE/TNGIHcX0XHKjTufDRMEGifB0QTVxnF3QAs/C++7zPg5auqsy+8UGaNYJvOh6CsbBxaYoq/GWkK5c6PFWDEOANl60aO9P610Z7xDsRzHM6Sp+wxzYL7PPpJUuT7Lg0af4yU3g8UNZ9PSdQZ6W2jCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=L9KOUEVH; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="L9KOUEVH"
Message-ID: <89354794-c53a-4935-a961-818710ba2fd3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714469423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lC3I7ZBJaD+fg9kzuIidBBEutjLohficzyxGQXhxxlA=;
	b=L9KOUEVHAb9nJPSEIiH9SMTkMWT9y+C2fYeSRTKOnztJoXFFijlJ0IaRzxCQ+4vzV4Py3i
	TEJwMOyMW83eL/y2MxsN3jPpBr06bFybhmyWNu0QNRap6kyotLUepdUzpP2pk8Xdd74Wvs
	Q4LB9nZlGKu+UEMgYRwC+7WOybcrqcM=
Date: Tue, 30 Apr 2024 17:29:54 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: bcachefs: Fix error path of bch2_link_trans()
To: Markus Elfring <Markus.Elfring@web.de>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 Youling Tang <tangyouling@kylinos.cn>, linux-bcachefs@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
References: <ww5fcxuzfcgttglsr6cpnrxufeusw4ixe76iqp7mab3djlyfje@zozue6qvxhzy>
 <7d4a29a1-26d2-4b22-8823-ce8e7f9ac534@web.de>
Content-Language: en-US, en-AU
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Youling Tang <youling.tang@linux.dev>
In-Reply-To: <7d4a29a1-26d2-4b22-8823-ce8e7f9ac534@web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi, Kent

On 30/04/2024 17:18, Markus Elfring wrote:
>>> In bch2_link_trans(), if bch2_inode_nlink_inc() fails, it needs to
>>> call bch2_trans_iter_exit() in the error path.
>> Thanks - applied.
> https://evilpiepirate.org/git/bcachefs.git/commit/?id=d04db1c7653dee5ee5f918ce951c05eefddad7eb
>
> Would it have been nice to add the tag “Fixes” (besides an imperative wording) accordingly?
The following labels can be added:
Fixes: 962ad1a7666 ("bcachefs: Don't BUG_ON() inode link count underflow")

Thanks,
Youling.
