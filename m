Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fTQXJdVH"
Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599F594
	for <linux-bcachefs@vger.kernel.org>; Tue, 12 Dec 2023 09:44:38 -0800 (PST)
Date: Tue, 12 Dec 2023 12:44:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1702403076;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ayNIJX9ZKA4+L4JrlwKUdEpl34lfGrs2/j+8/PgGjaY=;
	b=fTQXJdVHQzJdzihkSiEFWUIgS4JYUv63jbrjaTrZZZeUse+wK6PWrZeR0xcbPM0wZ9nY/l
	DsALd0V2BOjql+vYakt1zKk+boq91ytA4AFFZxVU9QKrFvJesJWjlXlgrptfLo6tjYiSqf
	p4i9s1IF76nrGiSOUTdGAYFxtOsufrM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Frank Filz <ffilzlnx@mindspring.com>
Cc: 'Theodore Ts'o' <tytso@mit.edu>, 'Donald Buczek' <buczek@molgen.mpg.de>,
	'Dave Chinner' <david@fromorbit.com>, 'NeilBrown' <neilb@suse.de>,
	linux-bcachefs@vger.kernel.org,
	'Stefan Krueger' <stefan.krueger@aei.mpg.de>,
	'David Howells' <dhowells@redhat.com>,
	linux-fsdevel@vger.kernel.org
Subject: Re: file handle in statx
Message-ID: <20231212174432.toj6c65mlqrlt256@moria.home.lan>
References: <20231208200247.we3zrwmnkwy5ibbz@moria.home.lan>
 <170233460764.12910.276163802059260666@noble.neil.brown.name>
 <20231211233231.oiazgkqs7yahruuw@moria.home.lan>
 <170233878712.12910.112528191448334241@noble.neil.brown.name>
 <20231212000515.4fesfyobdlzjlwra@moria.home.lan>
 <170234279139.12910.809452786055101337@noble.neil.brown.name>
 <ZXf1WCrw4TPc5y7d@dread.disaster.area>
 <e07d2063-1a0b-4527-afca-f6e6e2ecb821@molgen.mpg.de>
 <20231212152016.GB142380@mit.edu>
 <0b4c01da2d1e$cf65b930$6e312b90$@mindspring.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b4c01da2d1e$cf65b930$6e312b90$@mindspring.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 12, 2023 at 09:15:29AM -0800, Frank Filz wrote:
> > On Tue, Dec 12, 2023 at 10:10:23AM +0100, Donald Buczek wrote:
> > > On 12/12/23 06:53, Dave Chinner wrote:
> > >
> > > > So can someone please explain to me why we need to try to re-invent
> > > > a generic filehandle concept in statx when we already have a have
> > > > working and widely supported user API that provides exactly this
> > > > functionality?
> > >
> > > name_to_handle_at() is fine, but userspace could profit from being
> > > able to retrieve the filehandle together with the other metadata in a
> > > single system call.
> > 
> > Can you say more?  What, specifically is the application that would want
> to do
> > that, and is it really in such a hot path that it would be a user-visible
> > improveable, let aloine something that can be actually be measured?
> 
> A user space NFS server like Ganesha could benefit from getting attributes
> and file handle in a single system call.
> 
> Potentially it could also avoid some of the challenges of using
> name_to_handle_at that is a privileged operation.

which begs the question - why is name_to_handle_at() privileged?
