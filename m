Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727C93A8F8
	for <linux-bcachefs@vger.kernel.org>; Fri,  1 Mar 2024 15:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709305291; cv=none; b=PmrktXH6I9HEhkaogDs0ZdIs+i9Q1R2OF8WjlOgNbZ/urjzW3eDM8oN56aY7UeWuI4ygwtudoKOmsBIBAoEeqTyO4v5PjcuGxqASL+DDhttwgtdoJO3yA0lP7BYa9lqKDlmiy2STn6fs+iX4YQMS70Z4XD1pXryTEttjCUGRdlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709305291; c=relaxed/simple;
	bh=ERUK+MDr7h76tICDSai6O14g7fu2rTNwoDp0AUWnhMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E6L6oGD0cLkdAI69fb62v6wzY8nMe+0YBM+3qRlW7DBLy/+w5pCTvZaO2ZUPiFI4WuW/99nhqJPv5hNAmnml4Mj4MyhcjreXufxmcgFSBYeoB2h/dgbpkDdchgBUxVhJYG3tAI/wgDDhh/1bsMb4jr6QO68rlMmDnW8gp3Lti1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BzKOx16t; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BzKOx16t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709305288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h2DPueeqFYkRZUwqD/vr2uzl6MwQXTsD7wTc6ZLo2F0=;
	b=BzKOx16tABweugfHWSAE9iK7bjL6hnTqxBv3oDsHdzKUEM670Km6+9ONvwrHesJNBaoxZO
	8ii+DbFNQeROJ6d1Y2FQbHb0W6q1kjvcN5BpNbIQvPzC3NbdoUHyaNW/qgHO0D7wNl3FjF
	Qq+hGT+sTHpTrr/XRJ8wJu8nZH9LJVQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-92-srloWFL3MSietjrkSqTZhg-1; Fri, 01 Mar 2024 10:01:25 -0500
X-MC-Unique: srloWFL3MSietjrkSqTZhg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7488583B82C;
	Fri,  1 Mar 2024 15:01:24 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.137])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 37D0E1C060AF;
	Fri,  1 Mar 2024 15:01:24 +0000 (UTC)
Date: Fri, 1 Mar 2024 10:03:06 -0500
From: Brian Foster <bfoster@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
	djwong@kernel.org
Subject: Re: [PATCH 01/21] bcachefs: KEY_TYPE_accounting
Message-ID: <ZeHuKv4ciR22X87z@bfoster>
References: <20240225023826.2413565-1-kent.overstreet@linux.dev>
 <20240225023826.2413565-2-kent.overstreet@linux.dev>
 <Zd4Ef49kHX3g69VT@bfoster>
 <t6cc6gqgla2csyvrsv2znel5lg76vx7t2zna772qpw7zd6pnft@rxdakxza5cab>
 <ZeDQQ8cyMTgYaY6D@bfoster>
 <r2ieuj2kvitrrg7sqhuossm3wn4zzlkhygfqx7bxorzbaylnw2@kpgfn4e42iuw>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <r2ieuj2kvitrrg7sqhuossm3wn4zzlkhygfqx7bxorzbaylnw2@kpgfn4e42iuw>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

On Thu, Feb 29, 2024 at 04:24:37PM -0500, Kent Overstreet wrote:
> On Thu, Feb 29, 2024 at 01:43:15PM -0500, Brian Foster wrote:
> > Hmm.. I think the connection I missed on first look is basically
> > disk_accounting_key_to_bpos(). I think what is confusing is that calling
> > this a key makes me think of bkey, which I understand to contain a bpos,
> > so then overlaying it with a bpos didn't really make a lot of sense to
> > me conceptually.
> >
> > So when I look at disk_accounting_key_to_bpos(), I see we are actually
> > using the bpos _pad field, and this structure basically _is_ the bpos
> > for a disk accounting btree bkey. So that kind of makes me wonder why
> > this isn't called something like disk_accounting_pos instead of _key,
> > but maybe that is wrong for other reasons.
> 
> hmm, I didn't consider calling it disk_accounting_pos. I'll let that
> roll around in my brain.
> 
> 'key' is more standard terminology to me outside bcachefs, but 'pos'
> does make more sense within bcachefs.
> 

Ok, so I'm not totally crazy at least. :)

Note again that wasn't an explicit suggestion, just that it seems more
logical to me based on my current understanding. I'm just trying to put
down my initial thoughts/confusions in hopes that at least some of this
triggers ideas for improvements...

> > Either way, what I'm trying to get at is that I think this documentation
> > would be better if it explained conceptually how disk_accounting_key
> > relates to bkey/bpos, and why it exists separately from bkey vs. other
> > key types, rather than (or at least before) getting into the lower level
> > side effects of a union with bpos.
> 
> Well, that gets into some fun territory - ideally bpos would not be a
> fixed thing that every btree was forced to use, we'd be able to define
> different types per btree.
> 

Ok, but this starts to sound orthogonal to the accounting bits. Since I
don't really grok why this is called a key, here's how I would add to
the existing documentation:

"Here, the key has considerably more structure than a typical key
(bpos); an accounting key is 'struct disk_accounting_key', which is a
union of bpos. We do this because disk_account_key actually is bpos for
the related bkey that ends up in the accounting btree.

This btree uses nontraditional bpos semantics because accounting btree
keys are indexed differently <reasons based on the counter
structures..?>. Yadda yadda..

Unlike with other key types, <continued existing comment> ...
"

Hm?

Brian

> And we're actually going to need to be able to do that in order to do
> configurationless autotiering - i.e. tracking how hot/cold data is on an
> inode:offset basis, because LRU btree backreferences need to go in the
> key (bpos), not the value, in order to avoid collisions, and bpos isn't
> big enough for that.
> 
> disk_accounting_(key|pos) is an even trickier situation, because of
> endianness issues. The trick we do with bpos of defining the field order
> differently based on endianness so that byte order matches word order -
> that really wouldn't work here, so there is at present no practical way
> that I know of to avoid the byte swabbing when going back and forth
> between bpos and disk_accounting_pos on big endian.
> 
> But gcc does have an attribute now that lets you specify that an integer
> struct member is big or little endian... I if we could get them to go
> one step further and give us an attribute to control whether members are
> laid out in ascending or descending order...
> 

