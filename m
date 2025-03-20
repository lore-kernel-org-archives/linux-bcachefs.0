Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BE11D5CDD;
	Thu, 20 Mar 2025 05:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742449258; cv=none; b=KHwtmpLX8hZ9OIMMSPpTzBstQpUK/p+BTPfkFCXwJbpvFQXf2vCNzWnWuM19dhiJPNYjZ22ug4pvimYOvmeibQGjUmhIQUVqk5ZL+515EDEx5EQfGe3/Z4+ocgiMLTYIkhrWVa/jUTaRbTjRqx0LlwjLtxWqqu1YtvRLUJq+glY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742449258; c=relaxed/simple;
	bh=yVP95352tdKTv5jPzkV8bc73sjyc7y/bZaz0EIRfw6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HhTjX/BIAZEv8Czcn6gxRAjfFf31TrQxJNPTDrX56r+9JHdcIs6igg1nSOLjRw40as/+iXuUSGzvNPZpZe3qbQBIDw2yKetmGsYiF/K4yHneKuwY+8opmbqk0qJ6rTc7mKIKQJwngs0uivdhVmgYMldnUJzLNlBFG8F9IdKxTo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NIv7txlQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NIv7txlQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PBM/2lhu00fYUjGDP4I8DtUJAy8Baq39LUjxX7x/xrg=; b=NIv7txlQF12ouRg3vjC6FRawqf
	r2r0F8JbzW+fLaWf/ua5iZhW1vQLKp5LfEPMFTgfcG5OXlSsRmeEDwtdW1r47rVVp+ZJgVMiQmAx4
	8Pm7SxYjm8Kxm1J5EL2DD4XpWKjOc1RxW9n3wPC51L3/0Hn+9PZqZPY8Jrptwc4md1CBDbVnCOEW2
	uZjoqRXl8+7fftnGxhocHMtzHb8xHLOK2Or/snrqs4q5cltm7Heo1DE7hcgwCkYCn6M23bRZr9B1T
	a4Bye82Ueav/PSVdAgqMBcY6v2RnVVCNp8ofAcApKkM5eIf5srGx3NvPVZ4dAf/6Tu45Ojtn2x9Aa
	qM75QHHA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tv8eD-0000000BEtG-30HK;
	Thu, 20 Mar 2025 05:40:53 +0000
Date: Wed, 19 Mar 2025 22:40:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Keith Busch <kbusch@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 13/14] block: Allow REQ_FUA|REQ_READ
Message-ID: <Z9uqZS7QmjSvMlA5@infradead.org>
References: <yq1bjtzfyen.fsf@ca-mkp.ca.oracle.com>
 <zjwvemsjlshzm5zes7jznmhchvf2erebmuil4ssnkax3lwpw3a@5gnzbjlta36f>
 <Z9h25wvi0VQOaGh2@kbusch-mbp.dhcp.thefacebook.com>
 <ysvt4npanz4qfoxm5cv627cq2ommq6rxpka6pkvl3l2crcatmc@ic7tn5tt7aw4>
 <Z9iIa770ySTgKgp0@kbusch-mbp.dhcp.thefacebook.com>
 <566e4f59-4aaa-4d8e-b61f-b27cf79c1201@acm.org>
 <4mqi7e74ji7j3pzfdhfncz2yz3vvvvb6jivtzry4pmljgygcg5@hd5pv2lddzeq>
 <18b03fe9-1f57-48ac-92e3-308d27c5d144@acm.org>
 <t4zch7xnj5j3ifnivw3fkhkjpjldk2mozk3ouhogi224ntalab@3jjt2j6crbxe>
 <Z9m3KSGxyt_HQ5oD@kbusch-mbp>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9m3KSGxyt_HQ5oD@kbusch-mbp>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 18, 2025 at 12:10:49PM -0600, Keith Busch wrote:
> Maybe just change the commit log. Read FUA has legit uses for persisting
> data as described by the specs. No need to introduce contested behavior
> to justify this patch, yah?

While not having a factually incorrect commit message is a great
start I still don't think we want it.  For one there is no actual
use case for the actual semantics, so why add it?  Second it still
needs all the proper per-driver opt-in as these sematncis are not
defined for all out protocols as I've already mentioned before.

But hey, maybe Kent can actually find other storage or file system
developers to support it, so having an at least technically correct
patch out on the list would be a big start, even if I would not expect
to Jens to take it in a whim.
