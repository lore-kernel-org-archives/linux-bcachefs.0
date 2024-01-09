Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124653A278
	for <linux-bcachefs@vger.kernel.org>; Tue,  9 Jan 2024 16:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DHQEaN8B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704818487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=212TQIwA7AAsHK6TwcwxUHtp2UfP88b46d6DWL+UuGc=;
	b=DHQEaN8BoNgeCqS21/k4/hRN9NhIXVm3CwXry2F6SPMudV/ZQT1FtOJd6AcT3wW0/3uHx2
	AkzqqRL9NCuj+Uz8qi2m+EDWOJAiSSjplOUDk59Cc/bozJZIX/02gh3F67nPnWIKZI4NI3
	h2i7JkTpYz8pHZmtZwE9sixVBb03llo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-228-kPsh-bWqPn6aP1K4bY7fsA-1; Tue, 09 Jan 2024 11:41:25 -0500
X-MC-Unique: kPsh-bWqPn6aP1K4bY7fsA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A3CC810B93A3;
	Tue,  9 Jan 2024 16:41:24 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.130])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 68D83295C;
	Tue,  9 Jan 2024 16:41:24 +0000 (UTC)
Date: Tue, 9 Jan 2024 11:42:41 -0500
From: Brian Foster <bfoster@redhat.com>
To: "Carl E. Thompson" <cet@carlthompson.net>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH 1/2] bcachefs: add fiemap delalloc extent detection
Message-ID: <ZZ13gdxGh8Tn5DdC@bfoster>
References: <20231219140215.300753-1-bfoster@redhat.com>
 <20231219140215.300753-2-bfoster@redhat.com>
 <20231219235742.fmon4qqvbabuxq6c@moria.home.lan>
 <ZZagv/f2lWOSMUSn@bfoster>
 <5sttczrkktgkivq5ncusst3rrjqi7hgpx4nswq2vjqn6iqr4b2@25hi2ukb2rh7>
 <ZZwV5ohFULB2Q2i9@bfoster>
 <1197499938.727.1704753283643@mail.carlthompson.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197499938.727.1704753283643@mail.carlthompson.net>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

On Mon, Jan 08, 2024 at 02:34:43PM -0800, Carl E. Thompson wrote:
> I'm not a kernel developer so feel free to ignore this.
> 
> > On 2024-01-08 7:33 AM PST Brian Foster <bfoster@redhat.com> wrote:
> 
> > ...
> 
> > 3. Logistically, this is likely to be a bit awkward for pretty much
> > everybody who has a history of working with C code.
> 
> I disagree with this point. The ability to declare variables anywhere has been around officially since c99 and unofficially for much longer. For half or more of the 50-year history of C it has been allowed so most people with longtime C experience aren't going to be confused.
> 
> In fact C **never** required that **all** variables be declared at the beginning of a function. C has always allowed variables to be declared at the beginning of **any** block including unattached / unconditional blocks which I have personally used to great effect to limit the scope of temporary variables and to declare them close to where they were used going as far back as the 80s.
> 

Ok, but I'm not referring to the pure act of declaring variables
differently (i.e. such as limiting scope, the other examples given,
etc.). I'm referring specifically to a policy where all function scope
variables are uniformly declared at first use rather than at
top-of-function.

> > In the context of kernel development, something also tells me this has
> > potential to be a tinderbox for a flamewar, but who knows.. ;P
> 
> Well that may be the **real** issue! From the outside the kernel developers seem reluctant to revisit old decisions... It's 2024 and the mailing lists still don't accept modern email formats (HTML) which seem like they would make discussion easier. I used to be one of those people who resisted the change and preferred text-based email only but it's now been decades. Time to let that one go!
> 
> > ...
> 

Hah, well as a mutt user I have to disagree with the HTML thing. ;) But
to be fair, the fact that something might incite a flamewar in a
community that is historically pretty bad at level-headed discussion is
not a great argument. The real issue there is indeed something
different.

My concern with this was more that perhaps there might be indirect cost
to such a policy that might not be fully factored into the value
judgement of adopting it purely to minimize likelihood of a particular
class of bug.

Brian

