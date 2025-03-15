Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77AC51F561D;
	Sat, 15 Mar 2025 18:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742064101; cv=none; b=ua7D7F0jHr4AL3owpHS1AFIlADWPAd/Cv+jgE8Hz22NPhK/gh43LUgPekN+oPGT2XV1x6PCKhIEe+XUhxOzJPD/2ep5Vdn+Llwja5Rlx5fxqR3N4Qtppp+AoiVe/WtzITz3gGfMc6Z+vikQsjHSs4bpQI69+/cmAk1wbXgoJuoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742064101; c=relaxed/simple;
	bh=BcPZpCb5hUMBl2xPR4trisSVQQoDkDSi25QYkuo9OLU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZwXBMlrIVV0PRymK3QtLpGx26rg6MLjIa/wyYVvV22AIbWtUwHapLcNgSzdumOvu2RjmadL49IdL3oplIbO7chkjCMyHN2CWm5oR3BYPyaBvVfBHoNz9QfkFm4c+6EfNxH6xWF4fr+S+obKLFhWHlv27n/axbVhco+TJBS8a1Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rtKGBYBS; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rtKGBYBS"
Date: Sat, 15 Mar 2025 14:41:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742064096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BcPZpCb5hUMBl2xPR4trisSVQQoDkDSi25QYkuo9OLU=;
	b=rtKGBYBSngX7Vh9nOEZziCgVYr6SjyioyAjsHy6xwD/otmu+Zzw/tZTgkEX3pZ++NiCt/n
	kFKWsz5vTcm3UWLMSOPkXuWRLPXlHXUUR84KM7fjXqdvd/VkzouWC/sP67xa7JnmBO3/kv
	eIeeuz3bvsJILWNsYvneuM/8Kri5yyw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 13/14] block: Allow REQ_FUA|REQ_READ
Message-ID: <fy5lq7bxyr64f7oiypo343s57nujafjue2bcl72ovwszbzasxk@k6jhr6asqtmx>
References: <20250311201518.3573009-1-kent.overstreet@linux.dev>
 <20250311201518.3573009-14-kent.overstreet@linux.dev>
 <9db17620-4b93-4c01-b7f8-ecab83b12d0f@kernel.dk>
 <abk74sbsvsuijqhohyenl2mecz6unmkhavkga55fxsld6m6ise@ncbz3xmjlymw>
 <510692e2-b83c-45bc-8d9d-08f7a172ffe6@kernel.dk>
 <5ymzmc3u3ar7p4do5xtrmlmddpzhkqse2gfharr3nrhvdexiiq@p3hszkhipbgr>
 <0712e91f-2342-41ef-baad-3f2348f47ed6@kernel.dk>
 <ycsdpbpm4jbyc6tbixj3ujricqg3pszpfpjltb25b3qxl47tti@b2oydmcmf2a6>
 <ad32deb6-daad-4aa8-8366-2013b08e394f@kernel.dk>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad32deb6-daad-4aa8-8366-2013b08e394f@kernel.dk>
X-Migadu-Flow: FLOW_OUT

On Sat, Mar 15, 2025 at 12:32:49PM -0600, Jens Axboe wrote:
> Kent, let me make this really simple for you, since you either still
> don't understand how the development process works, or is under some
> assumption that it doesn't apply to you - get some of the decades of
> storage experience in that first thread to sign off on the patch and use
> case. The patch doesn't go upstream before that happens, simple as that.

No, you're the one who's consistently been under the assumption that it
doesn't apply to you.

You've got a history of applying patches to code that I maintain without
even CCing the list, let alone myself, and introducing silent data
corruption bugs into code that I wrote, without CCs, which I then had to
debug, and then putting up absolutely ridiculous fights to get fixed.

That's the sort of thing that process is supposed to avoid. To be clear,
you and Christoph are the two reasons I've had to harp on process in the
past - everyone else in the kernel has been fine.

As I said before, I'm not trying to bypass you without communicating -
but this has gone completely off the rails.
