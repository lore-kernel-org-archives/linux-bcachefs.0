Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783E5EACD
	for <linux-bcachefs@vger.kernel.org>; Tue, 18 Mar 2025 18:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742320840; cv=none; b=C/lEP26+eFHu6mZT9b5HQSyUNj+pHWtit2BTh5KJWY/Mel2qfZ9O9a8iCUZ70WAE2lk4I38zuau7dXGE/lkeNg4w5IEudRZtOAUCR36/3HlJY65zfrQ+5dA0vHwisF9CKhb3GghMnAvwGo0u2ADPQXMdhLhxeAqWaJo1Mx7VK2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742320840; c=relaxed/simple;
	bh=OBe+J6LQlVX6j16QG+Q3f14e6C8ahkBlu3zCzeL3EGI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cbVKxG9vbek6BqIUtbIDVkd0dNorll87tIGQfj2wrdTuKxAzcqsfs4wP8V2eyJ2Dne6Q4fJMokXa0TD3maoRH3WQwbawfKlihLddGldLbZjVppc+5GmlEnsVw7jE3dDVZQZso+hu8eYb07Snjoguhx+naz5k6vXXZUwwHLchokM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HeS32YWz; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HeS32YWz"
Date: Tue, 18 Mar 2025 14:00:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742320822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uO7as7XtwbqIVwCYdn+35OeuE0UCV7aq8O7vzxzqwKI=;
	b=HeS32YWzbZdqDjeEgsJKMl5Uh7A7kYmCh22/apEPTk90D0paZc6KD3nqhyhKc+CxqVKfJn
	PQJtPQY90Tt51uSaaQqO29PkmOwUg0cGQlFdK6UkQlIUbSd13OSK4RMYfLKHzWycSrd/dl
	ZC9EgsEuWhG2RfpVAjK4HkGVBm3Gh3I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Keith Busch <kbusch@kernel.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, 
	Jens Axboe <axboe@kernel.dk>, linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 13/14] block: Allow REQ_FUA|REQ_READ
Message-ID: <t4zch7xnj5j3ifnivw3fkhkjpjldk2mozk3ouhogi224ntalab@3jjt2j6crbxe>
References: <yq1msdjg23p.fsf@ca-mkp.ca.oracle.com>
 <qhc7tpttpt57meqqyxrfuvvfaqg7hgrpivtwa5yxkvv22ubyia@ga3scmjr5kti>
 <yq1bjtzfyen.fsf@ca-mkp.ca.oracle.com>
 <zjwvemsjlshzm5zes7jznmhchvf2erebmuil4ssnkax3lwpw3a@5gnzbjlta36f>
 <Z9h25wvi0VQOaGh2@kbusch-mbp.dhcp.thefacebook.com>
 <ysvt4npanz4qfoxm5cv627cq2ommq6rxpka6pkvl3l2crcatmc@ic7tn5tt7aw4>
 <Z9iIa770ySTgKgp0@kbusch-mbp.dhcp.thefacebook.com>
 <566e4f59-4aaa-4d8e-b61f-b27cf79c1201@acm.org>
 <4mqi7e74ji7j3pzfdhfncz2yz3vvvvb6jivtzry4pmljgygcg5@hd5pv2lddzeq>
 <18b03fe9-1f57-48ac-92e3-308d27c5d144@acm.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18b03fe9-1f57-48ac-92e3-308d27c5d144@acm.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 18, 2025 at 10:49:25AM -0700, Bart Van Assche wrote:
> On 3/17/25 6:06 PM, Kent Overstreet wrote:
> > What bcachefs is doing is entirely in line with the behaviour the
> > standard states.
> 
> I do not agree with the above.
> 
> Kent, do you plan to attend the LSF/MM/BPF summit next week? I'm
> wondering whether allowing REQ_FUA|REQ_READ would be a good topic
> for that summit.

No, I won't be there this year. And I don't think it'd be the right
forum for arguing over the meaning of an obscure line in the NVME spec,
anyways :)

It's certainly not in dispute that read fua is a documented, legitimate
command, so there's no reason for the block layer to be rejecting it.

Whether it has exactly the behaviour we want isn't a critical issue that
has to be determined right now. The starting point for that will be to
test device behaviour (with some simple performance tests, like I
mentioned), and anyways it's outside the scope of the block layer.
