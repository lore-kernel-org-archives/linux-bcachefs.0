Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9201B15820C
	for <linux-bcachefs@vger.kernel.org>; Wed, 12 Mar 2025 09:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741772468; cv=none; b=n46iYbj/e0PZub5jzkiTjUvT9AxpEmMejNHs6NOhUzZkG/3xTpDg0DxnyXXOBreizRgmmE79IDxV2tIsh4anM5/Nd6rNTt1yMfRESDfWldWpgY1lWvMwEVwm6K4376yQu99PcFFXP+aJtskL0P54NLcxvvdjZ5c5cp51QMd8b+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741772468; c=relaxed/simple;
	bh=uly2+c0WMscDYbPuevO+Nf3itBYPDXPsDDLKMrEuduI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wwwz+7zAxyvA/RLEU+al+VrKhb2Jv9u11NWF4eV5fpY/kAQS9YWI5Xde37HW0Rb5MFIquTSVjXXRQmogLhlAUwRKHuYkucMe0qM6NHnTYIBeEdj68twTwTjRZHoexy3bxgUUy8/8O4zfKb7T4838wGe+TVWeTFla1N6kfpDbt4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=box+8oOi; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="box+8oOi"
Date: Wed, 12 Mar 2025 05:40:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741772462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PMk2QSqJIQ2hqLoEI39z/pChPh1hBXiqu2Lx8QEOKls=;
	b=box+8oOi59yxpbT0wOvhaRnV8O8AofXlum7XKKB7KZbsvhAPvzaZOuowJscqgkwApMLvO4
	q0uElFqr1dRWqTWOH9rpKYzaNXNkMx7atakpfhrRHsri1Xd0UruNqbMUhehPj7Fqeoqw1t
	uYTqmloEQvLtT8hpqHEcxvtg32aZXJA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [bug report] bcachefs: Improve locking in
 __bch2_set_nr_journal_buckets()
Message-ID: <kxikhj6qludyuq6io75574e7gay2pf5nbnrrovq3fxznymv5hu@t6r5bjgwtaxq>
References: <e792b565-4017-4322-b33b-47f9ff0b77fe@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e792b565-4017-4322-b33b-47f9ff0b77fe@stanley.mountain>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 12, 2025 at 11:32:51AM +0300, Dan Carpenter wrote:
> Hello Kent Overstreet,
> 
> This is a semi-automatic email about new static checker warnings.
> 
> Commit 76966dbfa9eb ("bcachefs: Improve locking in
> __bch2_set_nr_journal_buckets()") from Feb 11, 2023, leads to the
> following Smatch complaint:
> 
> fs/bcachefs/journal.c:1184 bch2_set_nr_journal_buckets_iter() error: we previously assumed 'c' could be null (see line 1153)
> fs/bcachefs/journal.c:1187 bch2_set_nr_journal_buckets_iter() warn: variable dereferenced before check 'c' (see line 1184)
> 
> fs/bcachefs/journal.c
>   1183	
>   1184		bch2_write_super(c);
>                                  ^
> Unchecked dereference
> 
>   1185	
>   1186		/* Commit: */
>   1187		if (c)
>                     ^
> Checked too late
> 
>   1188			spin_lock(&c->journal.lock);
>   1189	
> 
> regards,
> dan carpenter

that code is just weird, it also depends on the new_fs param

(It's got to work for a bunch of different bringup situations, so
they've all got automated tests).
