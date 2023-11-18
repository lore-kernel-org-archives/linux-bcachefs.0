Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SHqyw0VI"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44931D5C
	for <linux-bcachefs@vger.kernel.org>; Sat, 18 Nov 2023 03:55:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700308500;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FpJYaWnjn61v2hTRrNbnNDF+9YwaNoe+fZbzEhgL7FQ=;
	b=SHqyw0VIb591yZgE/KKXZkY61dYEx99aYoBpRJIumSdnm/vlsfVGRcJ2mNd4hJ2IZJyvcQ
	FgJPbVwZjtqn1qteeCtk0UMlu0yz+vNRNHTZNR9OQKCY0rcaSQQdnfNQ1SslmP+2tFKH74
	AR24EKzBuJUgKNlkNjTS/+X/EQidECc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-h8YLETNrPW-SUrWP1XYicQ-1; Sat, 18 Nov 2023 06:54:58 -0500
X-MC-Unique: h8YLETNrPW-SUrWP1XYicQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 39051811E7B;
	Sat, 18 Nov 2023 11:54:58 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.99])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 05E0510EA1;
	Sat, 18 Nov 2023 11:54:57 +0000 (UTC)
Date: Sat, 18 Nov 2023 06:55:45 -0500
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] generic/459: improve shutdown/read-only check to
 accommodate bcachefs
Message-ID: <ZVimQVg0/5CNmC1S@bfoster>
References: <20231117144317.10882-1-bfoster@redhat.com>
 <20231117221434.GI36175@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231117221434.GI36175@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

On Fri, Nov 17, 2023 at 02:14:34PM -0800, Darrick J. Wong wrote:
> On Fri, Nov 17, 2023 at 09:43:17AM -0500, Brian Foster wrote:
> > generic/459 occasionally fails on bcachefs because the deliberately
> > induced I/O errors caused by exhausting the overprovisioned thin
> > pool can lead to filesystem shutdown. This test considers this
> > expected behavior on certain fs', but only checks for the ext4
> > remount read-only behavior. bcachefs does a similar emergency
> > read-only transition in response to certain I/O errors, but it
> > behaves more similar to an XFS shutdown and doesn't necessarily
> > reflect "ro" state in the mount table (unless induced by userspace).
> > 
> > Since the test already runs a touch command to help trigger the ext4
> > error handling sequence, this can be tweaked to serve double duty
> > and also more accurately detect read-only status on bcachefs.
> > Refactor into a small helper, check for an EROFS return to the touch
> > command, and consider the fs read-only if either that or the mount
> > entry check indicates it.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > Something I realized when writing up the commit log is that the EROFS
> > check doesn't technically cover XFS, which IIRC returns EIO in response
> > to any sorts of writes once the fs has shutdown. I'm not sure this
> > matters currently because XFS doesn't shutdown due to the default
> > behavior to retry failed I/Os, but technically if XFS were configured to
> > not retry I/O errors and go right to permanent failure, I suspect it
> > would fail this test in the same way bcachefs does.
> > 
> > That could be addressed fairly easily by also checking for EIO error
> > message output, or just assuming touch failure == shutdown, etc. I don't
> > have much preference on that, so thoughts appreciated.
> 
> I wish there was a better way to signal that a filesystem has shut down,
> though ATM that isn't even a VFS level concept.  I generally assume that
> touch failure == shutdown if the fs was previously writable.
> 

Yeah, mildly annoying there was no good way to detect this. I think all
we really have atm is dmesg scraping to call out unexpected shutdowns.
That still needs to be added for bcachefs btw, but I've been holding off
because it leads to noise on various dm-flakey oriented tests and
whatnot that complain about shutdowns that otherwise seem to be expected
from bcachefs. Though perhaps the right thing to do there is to enable
it and just filter those tests out for the time being.

But that's a separate topic... It sounds reasonable to me to just use
the touch failure in this particular case. I'll post a v2 with that
tweak next week.

> OTOH with statmount landing soonish, perhaps we ought to apply for a new
> SB_SHUTDOWN state flag for it to export?
> 

Perhaps worth a discussion..? The flipside I suppose is that shutdown
has historically been a rather hacky, informalized thing with
inconsistent behavior across fs' simply because it's a last ditch
failsafe technique that we hope should never happen. Is it worth trying
to generalize/formalize/document something that is basically a "has my
filesystem crashed?" check..?

We do have the vfs GOINGDOWN ioctl. I wonder if something like a new
flag for a nomodify/check goingdown mode or something that would return
whether a shutdown would occur or already has would be sufficient... hm?

Brian

> --D
> 
> > Brian
> > 
> >  tests/generic/459 | 30 +++++++++++++++++++++++-------
> >  1 file changed, 23 insertions(+), 7 deletions(-)
> > 
> > diff --git a/tests/generic/459 b/tests/generic/459
> > index 4dd7a43b..d0c48325 100755
> > --- a/tests/generic/459
> > +++ b/tests/generic/459
> > @@ -57,6 +57,26 @@ origpsize=200
> >  virtsize=300
> >  newpsize=300
> >  
> > +# Check whether the filesystem has shutdown or remounted read-only. Behavior can
> > +# differ based on filesystem and configuration. Some fs' may not have remounted
> > +# without an additional write while others may have shutdown but do not
> > +# necessarily reflect read-only state in the mount options. Check both here to
> > +# cover the various scenarios.
> > +is_shutdown_or_ro()
> > +{
> > +	ro=0
> > +
> > +	# if the fs has not shutdown, this may help trigger a remount-ro
> > +	touch $SCRATCH_MNT/newfile 2>&1 | \
> > +		grep "Read-only file system" > /dev/null
> > +	[ $? == 0 ] && ro=1
> > +
> > +	_fs_options /dev/mapper/$vgname-$snapname | grep -w "ro" > /dev/null
> > +	[ $? == 0 ] && ro=1
> > +
> > +	echo $ro
> > +}
> > +
> >  # Ensure we have enough disk space
> >  _scratch_mkfs_sized $((350 * 1024 * 1024)) >>$seqres.full 2>&1
> >  
> > @@ -113,13 +133,9 @@ ret=$?
> >  #	- The filesystem stays in Read-Write mode, but can be frozen/thawed
> >  #	  without getting stuck.
> >  if [ $ret -ne 0 ]; then
> > -	# freeze failed, filesystem should reject further writes and remount
> > -	# as readonly. Sometimes the previous write process won't trigger
> > -	# ro-remount, e.g. on ext3/4, do additional touch here to make sure
> > -	# filesystems see the metadata I/O error.
> > -	touch $SCRATCH_MNT/newfile >/dev/null 2>&1
> > -	ISRO=$(_fs_options /dev/mapper/$vgname-$snapname | grep -w "ro")
> > -	if [ -n "$ISRO" ]; then
> > +	# freeze failed, filesystem should reject further writes
> > +	ISRO=`is_shutdown_or_ro`
> > +	if [ $ISRO == 1 ]; then
> >  		echo "Test OK"
> >  	else
> >  		echo "Freeze failed and FS isn't Read-Only. Test Failed"
> > -- 
> > 2.41.0
> > 
> > 
> 

