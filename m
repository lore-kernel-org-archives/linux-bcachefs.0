Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4657465
	for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jan 2024 03:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705461482; cv=none; b=gKF4YxvrWY+dGblPcpsiqPjOeREO/tqHGz6rAD3msZS/Ha+7OYfVn8Q6fLBu1zIwfEmh1JI3hFLJFLtCWJNe2kk+lcj1I1fB/Gu8JpqeaSB+ubehtF5ztW/1/R5qiVPzeKDEKfSlDI6a0+mY+aWUdzZsrAeGR9En24wu2ttPgO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705461482; c=relaxed/simple;
	bh=7ws7oJBn7ayEXhi2i8pibDLQzoQCCAw3b2l/beH8h6k=;
	h=Date:DKIM-Signature:X-Report-Abuse:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Migadu-Flow; b=p70xp4BzmkSGuwv0NgfKoACnDURqgItnen88K9zxnZbl+A/ptX/HbYn/NjEj8GG1aH6E3hXUDZyKK1Dw3YtAvKRpsVzYaIXGP8lhjv+tknyMi4TsgoJrH3SiDFaJRU+opKMm6GSeI7dEWUabaFzrT18JXosyVbqZAl7d26X56s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NPIIzQPT; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NPIIzQPT"
Date: Tue, 16 Jan 2024 22:17:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1705461478;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zM8monDCKnWTacWI1Ko7Ygc2btXXnsPEGVyeSy9AdTU=;
	b=NPIIzQPTgFQuWQ4itLZjGnHkPfWxGZhXW8NQVws1JbQXCxof7mVp1NYu/8JSHOLXiGHmEH
	m7OQeWcXcwd21Y0wjo6oXk5bzAdwezDApCwvPtmMrbKuTPI+9oquYVeH1Ujjonsasq4JLd
	NlTJO0o7gyzqzcXo9Ssnphm9VUmPQzk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: call function with semicolon, not comma
Message-ID: <qr4ogoehndbuixivrlkytyj5s77ua6v6rxkza3sghcizbradh4@cx57w67lijlb>
References: <20240116234309.161341-1-alex_y_xu.ref@yahoo.ca>
 <20240116234309.161341-1-alex_y_xu@yahoo.ca>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240116234309.161341-1-alex_y_xu@yahoo.ca>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 16, 2024 at 06:43:09PM -0500, Alex Xu (Hello71) wrote:
> Technically the comma is equivalent here, but it's confusing and will
> break if it becomes the last line in the block.
> 
> Fixes: e99d90c4977 ("bcachefs: fix incorrect usage of REQ_OP_FLUSH")
> 
> Signed-off-by: Alex Xu (Hello71) <alex_y_xu@yahoo.ca>
> ---
>  fs/bcachefs/journal_io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
> index f074a6205bf8..7b2256e18132 100644
> --- a/fs/bcachefs/journal_io.c
> +++ b/fs/bcachefs/journal_io.c
> @@ -1989,7 +1989,7 @@ CLOSURE_CALLBACK(bch2_journal_write)
>  
>  			bio = ca->journal.bio;
>  			bio_reset(bio, ca->disk_sb.bdev,
> -					REQ_OP_WRITE | REQ_PREFLUSH),
> +					REQ_OP_WRITE | REQ_PREFLUSH);
>  			bio->bi_end_io		= journal_write_endio;
>  			bio->bi_private		= ca;
>  			closure_bio_submit(bio, cl);
> -- 
> 2.43.0
> 

Thanks, I'm going to squash this in with the commit that introduced it
